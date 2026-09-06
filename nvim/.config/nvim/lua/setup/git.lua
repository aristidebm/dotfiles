-- source: https://github.com/FabijanZulj/blame.nvim?tab=readme-ov-file#configuration
require("blame").setup({
  commit_detail_view = "tab",
  mappings = {
    commit_info = "i",
    show_commit = "O",
    close = { "q" },
  },
})

-- Git Remapping

vim.keymap.set("n", "<leader>gb", function()
  vim.cmd.BlameToggle("window")
end, { desc = "[G]it [B]lame" })

vim.keymap.set("n", "<leader>gs", vim.cmd.Git)

