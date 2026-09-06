-- Fore more information about fetchers look for them
-- inside https://github.com/NixOS/nixpkgs/tree/fe51cafc23ab7c226b1201d6c17713232bbfafc7/pkgs/build-support
-- https://nixos.org/manual/nixpkgs/stable/#fetchurl
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets("nix", {
  s("fetchurl", {
    t("builtins.fetchurl {"),
    t({ "", "  url = \"" }), i(1), t("\";"),
    t({ "", "  hash = " }), i(2, "lib.fakeHash"), t(";"),
    t({ "", "}" }), i(0),
  }),
  s("fetchGit", {
    t("builtins.fetchGit {"),
    t({ "", "  url = \"" }), i(1), t("\";"),
    t({ "", "  name = \"" }), i(2), t("\";"),
    t({ "", "  rev = \"" }), i(3), t("\";"),
    t({ "", "  hash = " }), i(4, "lib.fakeHash"), t(";"),
    t({ "", "}" }), i(0),
  }),
  s("fetchTarball", {
    t("builtins.fetchTarball {"),
    t({ "", "  url = \"" }), i(1), t("\";"),
    t({ "", "  name = \"" }), i(2), t("\";"),
    t({ "", "  rev = \"" }), i(3), t("\";"),
    t({ "", "  hash = " }), i(4, "lib.fakeHash"), t(";"),
    t({ "", "}" }), i(0),
  }),
  s("fetchTree", {
    t("builtins.fetchTree {"),
    t({ "", "  url = \"" }), i(1), t("\";"),
    t({ "", "  name = \"" }), i(2), t("\";"),
    t({ "", "  rev = \"" }), i(3), t("\";"),
    t({ "", "}" }), i(0),
  }),
  s("fetchzip", {
    t("fetchzip {"),
    t({ "", "  url = \"" }), i(1), t("\";"),
    t({ "", "  hash = " }), i(2, "lib.fakeHash"), t(";"),
    t({ "", "}" }), i(0),
  }),
  s("fetchMercurial", {
    t("builtins.fetchMercurial {"),
    t({ "", "  url = \"" }), i(1), t("\";"),
    t({ "", "  name = \"" }), i(2), t("\";"),
    t({ "", "  rev = \"" }), i(3), t("\";"),
    t({ "", "  hash = " }), i(4, "lib.fakeHash"), t(";"),
    t({ "", "}" }), i(0),
  }),
  s("fetchFromGitHub", {
    t("fetchFromGitHub {"),
    t({ "", "  owner = \"" }), i(1), t("\";"),
    t({ "", "  repo = \"" }), i(2), t("\";"),
    t({ "", "  rev = \"" }), i(3), t("\";"),
    t({ "", "  hash = " }), i(4, "lib.fakeHash"), t(";"),
    t({ "", "}" }), i(0),
  }),
  s("fetchFromGitlab", {
    t("fetchFromGitlab {"),
    t({ "", "  owner = \"" }), i(1), t("\";"),
    t({ "", "  repo = \"" }), i(2), t("\";"),
    t({ "", "  rev = \"" }), i(3), t("\";"),
    t({ "", "  hash = " }), i(4, "lib.fakeHash"), t(";"),
    t({ "", "}" }), i(0),
  }),
  s("fetchFromCodeberg", {
    t("fetchFromCodeberg {"),
    t({ "", "  owner = \"" }), i(1), t("\";"),
    t({ "", "  repo = \"" }), i(2), t("\";"),
    t({ "", "  rev = \"" }), i(3), t("\";"),
    t({ "", "  hash = " }), i(4, "lib.fakeHash"), t(";"),
    t({ "", "}" }), i(0),
  }),
  s("fetchFromGitea", {
    t("fetchFromGitea {"),
    t({ "", "  owner = \"" }), i(1), t("\";"),
    t({ "", "  repo = \"" }), i(2), t("\";"),
    t({ "", "  rev = \"" }), i(3), t("\";"),
    t({ "", "  hash = " }), i(4, "lib.fakeHash"), t(";"),
    t({ "", "}" }), i(0),
  }),
})
