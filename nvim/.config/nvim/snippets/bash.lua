local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node

ls.add_snippets("bash", {
  s("env", {
    t("#!/usr/bin/env sh"),
  }),
})
