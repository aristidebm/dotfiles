vim.opt_local.commentstring = "# %s"

-- Choose a request from a picker
vim.keymap.set("n", "<leader>f", function()
  require("kulala").search()
end, { buffer = 0 })

-- Export the request to curl
vim.keymap.set("n", "<leader>x", function()
  require("kulala").copy()
end, { buffer = 0 })

vim.keymap.set("n", "<leader>i", function()
  require("kulala").from_curl()
end, { buffer = 0 })

-- run the selected request
vim.keymap.set("", "<C-CR>", function()
  require("kulala").run()
end, { buffer = 0 })
