require("namu").setup({
  namu_symbols = {
    options = {
      display = {
        -- mode = "raw",
        format = "tree_guides",
      },
    },
  },
})

vim.keymap.set("n", "<leader>pd", "<CMD>Namu symbols<CR>", { desc = "[P]roject [D]ocument symbols" })
