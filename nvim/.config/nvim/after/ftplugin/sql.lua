vim.keymap.set(
  "n",
  "<C-CR>",
  "<CMD>normal vip<CR><PLUG>(DBUI_ExecuteQuery)",
  { buffer = true, desc = "Run query under cursor" }
)
vim.keymap.set("v", "<C-CR>", "<PLUG>(DBUI_ExecuteQuery)", { buffer = true, desc = "Run selected query" })
