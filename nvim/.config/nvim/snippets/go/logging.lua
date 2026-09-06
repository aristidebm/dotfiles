local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets("go", {
  s("debug", {
    t('slog.Debug("'),
    i(1),
    t('")'),
  }),
})

ls.add_snippets("go", {
  s("info", {
    t('slog.Info("'),
    i(1),
    t('")'),
  }),
})

ls.add_snippets("go", {
  s("warning", {
    t('slog.Warning("'),
    i(1),
    t('")'),
  }),
})

ls.add_snippets("go", {
  s("error", {
    t('slog.Error("'),
    i(1),
    t('")'),
  }),
})
