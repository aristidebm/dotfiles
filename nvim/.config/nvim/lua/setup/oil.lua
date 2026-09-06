require("oil").setup({
  -- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
  -- Set to false if you still want to use netrw.
  default_file_explorer = false,
  -- Id is automatically added at the beginning, and name at the end
  -- See :help oil-columns
  -- Send deleted files to the trash instead of permanently deleting them (:help oil-trash)
  delete_to_trash = true,
  -- Skip the confirmation popup for simple operations (:help oil.skip_confirm_for_simple_edits)
  skip_confirm_for_simple_edits = true,
  view_options = {
    -- Show files and directories that start with "." (you can gi to show toggle)
    show_hidden = true,
    -- This function defines what is considered a "hidden" file
    is_hidden_file = function(name, bufnr)
      return vim.startswith(name, ".")
    end,
    -- This function defines what will never be shown, even when `show_hidden` is set
    is_always_hidden = function(name, bufnr)
      local always_hiddens = { __pycache__ = true }
      return always_hiddens[name]
    end,
    -- Sort file names in a more intuitive order for humans. Is less performant,
    -- so you may want to set to false if you work with large directories.
    natural_order = true,
    sort = {
      -- sort order can be "asc" or "desc"
      -- see :help oil-columns to see which columns are sortable
      { "type", "asc" },
      { "name", "asc" },
    },
  },
  keymaps = {
    ["<C-s>"] = { "actions.select", opts = { horizontal = true }, desc = "Open the entry in a horizontal split" },
    ["|"] = { "actions.select", opts = { vertical = true }, desc = "Open the entry in a vertical split" },
  },
})

-- vim.keymap.set("n", "-", "<CMD>Oil --float<CR>", { desc = "Open parent directory" })
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
-- source: https://www.reddit.com/r/neovim/comments/1bceiw2/oilnvim_vs_minifiles/
-- vim.api.nvim_create_user_command("Explore", "Oil <args>", { nargs = "?", complete = "dir" })
-- vim.api.nvim_create_user_command("E", "Explore <args>", { nargs = "?", complete = "dir" })
-- vim.api.nvim_create_user_command("Sexplore", "belowright split | Oil <args>", { nargs = "?", complete = "dir" })
-- vim.api.nvim_create_user_command("Vexplore", "rightbelow vsplit | Oil <args>", { nargs = "?", complete = "dir" })
-- vim.api.nvim_create_user_command("Texplore", "tabedit % | Oil <args>", { nargs = "?", complete = "dir" })
