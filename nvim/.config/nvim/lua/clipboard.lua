local path = require("path")

local M = {}

function M.copy_to_clipboard(value)
  vim.fn.setreg("+", value)
end

local function _yank_file_location(path, target)
  local line = vim.fn.line(".")
  local col = vim.fn.col(".")
  local location = target == "vim" and string.format("+%d:%d %s", line, col, path)
    or string.format("%s:%d:%d", path, line, col)
    M.copy_to_clipboard(location)
end

local function yank_file_path_relative_to_workdir(target)
  local value = path.normalize_path_from_cwd(vim.fn.expand("%:p"), path.getcwd())
  _yank_file_location(value, target)
end

local function yank_full_qualified_name(target)
  local value = path.normalize_path_from_cwd(vim.fn.expand("%:p"), path.getcwd())
  M.copy_to_clipboard(value:gsub("/", "."):gsub("%.py$", ""))
end

local function yank_file_path(target)
  _yank_file_location(vim.fn.expand("%:p"), target)
end

local function yank_file_name()
  local name = path.normalize_path_from_cwd(vim.fn.expand("%:p"), vim.fn.expand("%:p:h"))
  M.copy_to_clipboard(name)
end

local function yank_file_directory()
  local value = vim.fn.expand("%:p:h")
  M.copy_to_clipboard(value)
end

vim.keymap.set("n", "yp", function()
  yank_file_path("default")
end, { desc = "[Y]ank [P]ath" })

vim.keymap.set("n", "yP", function()
  yank_file_path("vim")
end, { desc = "[Y]ank [P]ath" })

vim.keymap.set("n", "yr", function()
  yank_file_path_relative_to_workdir("default")
end, { desc = "[Y]ank [R]elative" })

vim.keymap.set("n", "yR", function()
  yank_file_path_relative_to_workdir("vim")
end, { desc = "[Y]ank [R]elative" })

vim.keymap.set("n", "yn", function()
  yank_file_name()
end, { desc = "[Y]ank [N]ame" })

vim.keymap.set("n", "ym", function()
  yank_full_qualified_name()
end, { desc = "[Y]ank [M]odule" })

vim.keymap.set("n", "yd", function()
  yank_file_directory()
end, { desc = "[Y]ank [D]irectory" })

return M
