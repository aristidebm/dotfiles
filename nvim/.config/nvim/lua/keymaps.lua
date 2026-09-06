-- Show file explorer.
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Arguments list management command
-- vim.keymap.set("n", "<leader>a", "<CMD>$argadd | argdedupe <CR>")

-- It is 0-based index but the first index always correspond
-- to the first argument passed nvim cli command and usually
-- it is the folder name (since I am used to nvim .)
-- vim.keymap.set("n", "<C-j>", "<CMD>execute 'edit' argv(1)<CR>")
-- vim.keymap.set("n", "<C-k>", "<CMD>execute 'edit' argv(2)<CR>")
-- vim.keymap.set("n", "<C-l>", "<CMD>execute 'edit' argv(3)<CR>")
-- vim.keymap.set("n", "<C-;>", "<CMD>execute 'edit' argv(4)<CR>")

-- Yank to system clipboard
vim.keymap.set("n", "<leader>Y", '"+y$')
vim.keymap.set({ "n", "x" }, "<leader>y", '"+y')

-- Move line/block up and down
-- vim.keymap.set("v","<S-j>", ":m '>+1<CR>gv=gv")
-- vim.keymap.set("v","<S-k>", ":m '<-2<CR>gv=gv")

-- fzf keybindings
--
--

-- Join the line below without moving my cursor.
vim.keymap.set("n", "<S-j>", "mzJ`z")

-- Keep my cursor centered when scrolling verticaly.
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
--
-- Center searches
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Source http://vimcasts.org/episodes/the-edit-command/
vim.keymap.set('c', '%%', function()
    return vim.fn.fnameescape(vim.fn.expand('%:h')) .. '/'
end, { expr = true })

local function edit_from_current_dir()
  local dir = vim.fn.expand('%:p:h')
  vim.fn.feedkeys(':edit ' .. vim.fn.fnameescape(dir) .. '/', 'n')
end

vim.keymap.set({'n'}, '<C-x><C-f>', edit_from_current_dir)

-- use Q to run a macro in selection mode
vim.keymap.set("x", "Q", function() vim.cmd.norm("Q") end)

-- Quickfix list management
-- Navigate quickfix list like diagnonstics list with [q and ]q
vim.keymap.set("n", "<leader>qq", require("quickfix").toggle)

-- Windows resizing
vim.keymap.set("n", "<C-W><", "15<C-W><")
vim.keymap.set("n", "<C-W>>", "15<C-W>>")
vim.keymap.set("n", "<C-W>+", "3<C-W>+")
vim.keymap.set("n", "<C-W>-", "3<C-W>-")
