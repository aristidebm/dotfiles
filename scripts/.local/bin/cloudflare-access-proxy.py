#!/usr/bin/env python3
# cf-access-proxy.py — local proxy that injects a Cloudflare Access token
# for CLI tools (like glab) that can't attach custom headers themselves.
#
# Requires: `cloudflared access login <APP_URL>` already run once, so
# `cloudflared access token -app=<APP_URL>` can return a cached JWT.

import argparse
import subprocess
import http.server
import urllib.request
import urllib.error
import functools

LISTEN_HOST = "127.0.0.1"
LISTEN_PORT = 8484

def get_token(app_url: str):
    # ["cloudflared", "access", "login", "--app", app_url],
    out = subprocess.run(
        ["cloudflared", "access", "token", "--app", app_url],
        capture_output=True, text=True, check=True,
    )
    return out.stdout.strip()


def read_chunked_body(rfile):
    """Decode an HTTP/1.1 chunked-transfer-encoded request body.

    glab sends POST bodies (review submissions, etc.) via `--input -`,
    piping from stdin — Go's net/http client doesn't know the length
    upfront in that case, so it uses `Transfer-Encoding: chunked` instead
    of `Content-Length`. The old body-reading logic only ever checked
    Content-Length, so chunked bodies were silently dropped (read as
    empty), while the Transfer-Encoding header was still forwarded
    upstream unchanged — sending Cloudflare/GitLab a request that promises
    chunked data and then sends none. That framing mismatch is exactly
    what a request-smuggling-aware edge resets the connection over.
    """
    body = b""
    while True:
        size_line = rfile.readline().strip()
        chunk_size = int(size_line.split(b";")[0], 16)
        if chunk_size == 0:
            # Consume trailing headers (if any) up to the blank line.
            while True:
                line = rfile.readline()
                if line in (b"\r\n", b"\n", b""):
                    break
            break
        body += rfile.read(chunk_size)
        rfile.readline()  # trailing CRLF after each chunk
    return body


class Proxy(http.server.BaseHTTPRequestHandler):
    # Required so BaseHTTPRequestHandler's built-in handle_expect_100()
    # actually responds to "Expect: 100-continue" (sent by Go's net/http
    # client, which glab uses, on any POST with a body). Under the default
    # HTTP/1.0 this header is ignored, the client hangs waiting for the
    # 100-continue response, and eventually resets the connection —
    # surfacing here as ConnectionResetError on POST-only requests like
    # review submission.
    protocol_version = "HTTP/1.1"


    def __init__(self,
        request,
        client_address,
        server,
        app_url: str,
        upstream: str
    ):
        self.app_url = app_url
        self.upstream = upstream
        super().__init__(request, client_address, server)

    def _forward(self):
        token = get_token(self.app_url)
        url = self.upstream + self.path
        req = urllib.request.Request(url, method=self.command)

        length = int(self.headers.get("Content-Length", 0))
        transfer_encoding = self.headers.get("Transfer-Encoding", "").lower()
        if "chunked" in transfer_encoding:
            body = read_chunked_body(self.rfile)
        else:
            body = self.rfile.read(length) if length else None

        # Forward incoming headers, but skip ones we need to control ourselves.
        # "expect" is dropped because glab's Go HTTP client sends
        # "Expect: 100-continue" on POSTs with a body, but urlopen() below
        # sends the full request (headers + body) in one shot rather than
        # doing the real two-phase 100-continue handshake. Forwarding the
        # header through unchanged makes the upstream edge (Cloudflare /
        # GitLab) expect a handshake we never perform.
        # "transfer-encoding" is dropped because we've already fully
        # decoded any chunked body above — urlopen() sends the decoded
        # bytes as a normal body with its own Content-Length, so forwarding
        # the original chunked header would mismatch what's actually sent.
        for k, v in self.headers.items():
            if k.lower() not in (
                "host", "content-length", "accept-encoding",
                "expect", "transfer-encoding",
            ):
                req.add_header(k, v)

        # Ask upstream not to gzip the response — otherwise glab receives
        # compressed bytes with no Content-Encoding header to decode them
        # (the proxy would need to decompress it itself), and chokes with
        # "invalid character '\x1f'" (the gzip magic byte) trying to parse
        # it as JSON.
        req.add_header("Accept-Encoding", "identity")

        # Cloudflare Access authentication.
        req.add_header("Cookie", f"CF_Authorization={token}")

        # Debug: log the outgoing request before attempting it, so a request
        # that crashes urlopen() (before send_response would normally log it)
        # is still visible in the output.
        print(f"--> {self.command} {url}")
        print(f"    body_size={len(body) if body else 0}")
        # for k, v in req.header_items():
        #     print(f"    header: {k}: {v}")

        try:
            with urllib.request.urlopen(req, data=body) as resp:
                self.send_response(resp.status)
                for k, v in resp.getheaders():
                    if k.lower() not in ("transfer-encoding", "content-encoding"):
                        self.send_header(k, v)
                self.end_headers()
                self.wfile.write(resp.read())
        except urllib.error.HTTPError as e:
            self.send_response(e.code)
            for k, v in e.headers.items():
                if k.lower() not in ("transfer-encoding", "content-encoding"):
                    self.send_header(k, v)
            self.end_headers()
            self.wfile.write(e.read())
        except urllib.error.URLError as e:
            self.send_response(502)
            self.end_headers()
            self.wfile.write(f"Proxy upstream error: {e}".encode())

    do_GET = do_POST = do_PUT = do_DELETE = do_PATCH = _forward

    def log_message(self, fmt, *args):
        # Keep default stderr logging; override only if you want to silence it.
        super().log_message(fmt, *args)


def main() -> int:
    parser = argparse.ArgumentParser(prog="cloudflare-access-proxy")
    parser.add_argument("--app-url", required=True, help="Cloudflare App URL (to pass to 'cloudflared access token -app')")
    parser.add_argument("--upstream", required=True, help="Upstream Git Repository URL")
    args = parser.parse_args()

    server = http.server.HTTPServer((LISTEN_HOST, LISTEN_PORT), functools.partial(Proxy, app_url=args.app_url, upstream=args.upstream))
    print(f"cf-access-proxy listening on http://{LISTEN_HOST}:{LISTEN_PORT} -> {args.upstream}")
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        pass


if __name__ == "__main__":
    main()
