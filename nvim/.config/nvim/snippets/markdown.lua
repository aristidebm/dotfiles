local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets("markdown", {
  s("table", {
    t("| "),
    i(1),
    t(" | "),
    i(2),
    t(" |"),
    t({ "", "| --- | --- |" }),
    t({ "", "| " }),
    i(3),
    t(" | "),
    i(4),
    t(" |"),
  }),
  s("code", {
    t("```"),
    i(1),
    t({ "", "" }),
    i(0),
    t({ "", "```" }),
  }),
  s("callout-note", {
    t({ "> [!NOTE]", "> " }),
    i(0),
  }),
  s("note", {
    t({ "> [!NOTE]", "> " }),
    i(0),
  }),
  s("callout-tip", {
    t({ "> [!TIP]", "> " }),
    i(0),
  }),
  s("tip", {
    t({ "> [!TIP]", "> " }),
    i(0),
  }),

  s("callout-important", {
    t({ "> [!IMPORTANT]", "> " }),
    i(0),
  }),

  s("important", {
    t({ "> [!IMPORTANT]", "> " }),
    i(0),
  }),

  s("callout-warning", {
    t({ "> [!WARNING]", "> " }),
    i(0),
  }),

  s("warning", {
    t({ "> [!WARNING]", "> " }),
    i(0),
  }),

  s("callout-caution", {
    t({ "> [!CAUTION]", "> " }),
    i(0),
  }),

  s("caution", {
    t({ "> [!CAUTION]", "> " }),
    i(0),
  }),
})
