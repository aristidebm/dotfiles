local ls = require("luasnip") -- Load LuaSnip
local rep = require("luasnip.extras").rep
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node

ls.add_snippets("http", {
  s("POST", {
    t("POST "),
    i(1, "https://httpbin.org/json"),
    t({ "", "" }),
    t("Authorization: "),
    i(2, "Token"),
    t({ "", "" }),
    t("Content-Type: "),
    i(3, "application/json"),
    t({ "", "" }),
    t("Accept: "),
    i(4, "application/json"),
    t({ "", "" }),
    t({ "", "" }),
    t("{"),
    t({ "", "\t" }),
    i(5, "..."),
    t({ "", "" }),
    t("}"),
  }),
  s("RESPONSE", {
    -- Status line
    t("HTTP/1.1 "),
    i(1, "200"),
    t(" "),
    i(2, "OK"),
    t({ "", "" }),

    -- Common headers
    t("Content-Type: "),
    i(3, "application/json"),
    t({ "", "" }),

    t("Content-Length: "),
    i(4, "4096"),
    t({ "", "" }),

    t("Cache-Control: "),
    i(5, "no-cache"),
    t({ "", "" }),

    t("Connection: "),
    i(6, "keep-alive"),
    t({ "", "" }),

    t("Date: "),
    i(7, "Tue, 19 Dec 2025 12:00:00 GMT"),
    t({ "", "" }),

    t("Server: "),
    i(8, "nginx"),
    t({ "", "" }),

    -- Optional body placeholder
    i(9, ""),
  })
})

ls.add_snippets("http", {
  s("PUT", {
    t("PUT "),
    i(1, "https://httpbin.org/json"),
    t({ "", "" }),
    t("Authorization: "),
    i(2, "Token"),
    t({ "", "" }),
    t("Content-Type: "),
    i(3, "application/json"),
    t({ "", "" }),
    t("Accept: "),
    i(4, "application/json"),
    t({ "", "" }),
    t({ "", "" }),
    t("{"),
    t({ "", "\t" }),
    i(5, "..."),
    t({ "", "" }),
    t("}"),
  }),
})

ls.add_snippets("http", {
  s("PATCH", {
    t("PATCH "),
    i(1, "https://httpbin.org/json"),
    t({ "", "" }),
    t("Authorization: "),
    i(2, "Token"),
    t({ "", "" }),
    t("Content-Type: "),
    i(3, "application/json"),
    t({ "", "" }),
    t("Accept: "),
    i(4, "application/json"),
    t({ "", "" }),
    t({ "", "" }),
    t("{"),
    t({ "", "\t" }),
    i(5, "..."),
    t({ "", "" }),
    t("}"),
  }),
})

ls.add_snippets("http", {
  s("GET", {
    t("GET "),
    i(1, "https://httpbin.org/json"),
    t({ "", "" }),
    t("Authorization: "),
    i(2, "Token"),
    t({ "", "" }),
    t("Accept: "),
    i(3, "application/json"),
  }),
  s("QUERY", {
    t("QUERY "),
    i(1, "https://httpbin.org/json"),
    t({ "", "" }),
    t("Authorization: "),
    i(2, "Token"),
    t({ "", "" }),
    t("Accept: "),
    i(3, "application/json"),
  }),
})

ls.add_snippets("http", {
  s("DELETE", {
    t("DELETE "),
    i(1, "https://httpbin.org/json"),
    t({ "", "" }),
    t("Authorization: "),
    i(2, "Token"),
    t({ "", "" }),
    t("Accept: "),
    i(3, "application/json"),
  }),
})

ls.add_snippets("http", {
  s("Content-Type", {
    t("Content-Type: "),
    c(1, {
      t("application/json"),
      t("application/x-www-form-urlencoded"),
    }),
  }),
})

ls.add_snippets("http", {
  s("Accept", {
    t("Accept: "),
    c(1, {
      t("application/json"),
      t("application/x-www-form-urlencoded"),
    }),
  }),
})

ls.add_snippets("http", {
  s("Access-Control-Allow-Origin", {
    t("Access-Control-Allow-Origin: "),
    c(1, {
      t("*"),
      i(1, "origin"),
    }),
  }),
})

ls.add_snippets("http", {
  s("Access-Control-Allow-Methods", {
    t("Access-Control-Allow-Methods: "),
    c(1, {
      t("*"),
      i(1, "method"),
    }),
  }),
})

ls.add_snippets("http", {
  s("Access-Control-Request-Method", {
    t("Access-Control-Request-Method: "),
    c(1, {
      t("GET"),
      t("POST"),
      t("PATCH"),
      t("PUT"),
      t("DELETE"),
      t("OPTIONS"),
      t("HEAD"),
      t("TRACE"),
      t("CONNECT"),
    }),
  }),
})

ls.add_snippets("http", {
  s("Access-Control-Request-Headers", {
    t("Access-Control-Request-Headers: "),
    c(1, {
      t("*"),
      i(1, "header"),
    }),
  }),
})

ls.add_snippets("http", {
  s("Access-Control-Allow-Headers", {
    t("Access-Control-Allow-Headers: "),
    c(1, {
      t("*"),
      i(1, "header"),
    }),
  }),
})
