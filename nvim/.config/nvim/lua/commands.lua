local function create_nonexistent_dir()
  local file = vim.fn.expand("<afile>")
  if file:match("^%w+:/") then
    return -- skip URLs or special filetypes
  end
  local dir = vim.fn.fnamemodify(file, ":h")
  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, "p") -- create with intermediate dirs
  end
end

local group = vim.api.nvim_create_augroup("AutoCreateDir", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
  group = group,
  pattern = "*",
  callback = create_nonexistent_dir,
})

-- Highlight yanked text using Lua API
vim.api.nvim_create_augroup("HighlightYank", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  group = "HighlightYank",
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ timeout = 100 })
  end,
})

-- Clear jump list on VimEnter event using Lua API
vim.api.nvim_create_augroup("ClearJumpsOnEnter", { clear = true })
vim.api.nvim_create_autocmd("VimEnter", {
  group = "ClearJumpsOnEnter",
  pattern = "*",
  callback = function()
    vim.cmd("clearjumps")
  end,
})

vim.api.nvim_create_augroup("TrimWhitespace", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
  group = "TrimWhitespace",
  pattern = "*",
  callback = function()
    local save = vim.fn.winsaveview()
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.winrestview(save)
  end,
})

-- -- Clear jump list on VimEnter event using Lua API
-- vim.api.nvim_create_augroup("SetBashScriptFileTypeOnEnter", { clear = true })
-- vim.api.nvim_create_autocmd("BufEnter", {
--   group = "SetBashScriptFileTypeOnEnter",
--   pattern = "~/Projects/personal/dotfiles/scripts/*",
--   callback = function()
--     vim.opt.filetype = "sh"
--   end,
-- })
