local M = {}

M.getcwd = function()
  -- Check if inside a git repository, get the git base directory if so otherwise
  -- fallback to vim.fn.getcwd(...)
  local path
  local handle = io.popen("git rev-parse --show-toplevel 2> /dev/null")
  if handle then
    path = handle:read("*a")
    handle:close()
    -- trim trailing whitespace/newlines
    path = path:gsub("%s+$", "")
  end

  if path == "" then
    path = vim.fn.getcwd()
  end
  return path
end

M.normalize_path_from_cwd = function (path, cwd)
  if vim.startswith(path, cwd) then
    path = path:sub(#cwd + 2) -- Remove the cwd prefix and the leading '/'
  end
  return path
end

return M
