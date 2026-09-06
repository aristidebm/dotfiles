local modes = {
  ["n"] = "NORMAL",
  ["no"] = "NORMAL",
  ["v"] = "VISUAL",
  ["V"] = "VISUAL LINE",
  [""] = "VISUAL BLOCK",
  ["s"] = "SELECT",
  ["S"] = "SELECT LINE",
  [""] = "SELECT BLOCK",
  ["i"] = "INSERT",
  ["ic"] = "INSERT",
  ["R"] = "REPLACE",
  ["Rv"] = "VISUAL REPLACE",
  ["c"] = "COMMAND",
  ["cv"] = "VIM EX",
  ["ce"] = "EX",
  ["r"] = "PROMPT",
  ["rm"] = "MOAR",
  ["r?"] = "CONFIRM",
  ["!"] = "SHELL",
  ["t"] = "TERMINAL",
}

-- returns the current mode
local function mode()
  local current_mode = vim.api.nvim_get_mode().mode
  return string.format(" %s ", modes[current_mode]):upper()
end

-- returns the file path, for more informations
-- on files modifiers, check h: filename-modifiers
local function filepath()
  local fpath = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.:h")
  if fpath == "" or fpath == "." then
    return " "
  end
  return string.format(" %%<%s/", fpath)
end

-- returns file basename (actual filename without path)
local function filename()
  local fname = vim.fn.expand("%:t")
  if fname == "" then
    return ""
  end
  return fname .. " "
end

-- returns the file type
local function filetype()
  return string.format(" %s ", vim.bo.filetype):upper()
end

-- returns buffer is modified
local function modified()
  return " %m"
end

-- returns diagnostics diagnotics
local function diagnostics()
  local count = {}
  local levels = {
    errors = "Error",
    warnings = "Warn",
    info = "Info",
    hints = "Hint",
  }

  for k, v in pairs(levels) do
    count[k] = vim.tbl_count(vim.diagnostic.get(0, { severity = v }))
  end

  local errors = ""
  local warnings = ""
  local hints = ""
  local info = ""

  if count["errors"] ~= 0 then
    errors = " %#LspDiagnosticsSignError# " .. count["errors"]
  end
  if count["warnings"] ~= 0 then
    warnings = " %#LspDiagnosticsSignWarning# " .. count["warnings"]
  end
  if count["hints"] ~= 0 then
    hints = " %#LspDiagnosticsSignHint# " .. count["hints"]
  end
  if count["info"] ~= 0 then
    info = " %#LspDiagnosticsSignInformation# " .. count["info"]
  end

  return errors .. warnings .. hints .. info .. "%#Normal#"
end

-- returns informations to show on the line
local function lineinfo()
  if vim.bo.filetype == "alpha" then
    return ""
  end
  return " %P %l:%c "
end

-- returns the number of selected lines
-- or characters in visual mode
-- :h showcmd and :h showcmdloc
local function showcmd()
  return " %S "
end

-- show macro recording sign (this is a workaround there is an ongoing thread on it
-- here https://www.reddit.com/r/neovim/comments/xy0tu1/comment/irfegvd/?context=3)
-- source https://www.reddit.com/r/neovim/comments/xy0tu1/comment/irfegvd/?context=3
local function show_macro_recording()
  local recording_register = vim.fn.reg_recording()
  if recording_register == "" then
    return ""
  else
    return "recording @" .. recording_register
  end
end

local function search_count()
  -- if vim.v.hlsearch == 0 then
  --     return ""
  -- end

  local sinfo = vim.fn.searchcount({ maxcount = 0 })
  local search_stat = sinfo.incomplete > 0 and "[?/?]"
    or sinfo.total > 0 and ("[%s/%s]"):format(sinfo.current, sinfo.total)
    or nil

  if search_stat == nil then
    return ""
  end

  return search_stat
end

-- local function LastSearchCount()
--   local result = vim.fn.searchcount({recompute = 0})
--   if next(result) == nil then
--     return ''
--   end
--   if result.incomplete == 1 then      -- timed out
--     return string.format(' /%s [?/??]', vim.fn.getreg('/'))
--   elseif result.incomplete == 2 then  -- max count exceeded
--     if result.total > result.maxcount and
--        result.current > result.maxcount then
--       return string.format(' /%s [>%d/>%d]', vim.fn.getreg('/'),
--                    result.current, result.total)
--     elseif result.total > result.maxcount then
--       return string.format(' /%s [%d/>%d]', vim.fn.getreg('/'),
--                    result.current, result.total)
--     end
--   end
--   return string.format(' /%s [%d/%d]', vim.fn.getreg('/'),
--                result.current, result.total)
-- end
--
-- build the statusline
Statusline = {}

Statusline.active = function()
  return table.concat({
    "%#Statusline#",
    mode(),
    "%#Normal#",
    filepath(),
    filename(),
    "%#Normal#",
    diagnostics(),
    "%#Normal#",
    modified(),
    "%=%#StatusLineExtra#",
    search_count(),
    -- LastSearchCount(),
    show_macro_recording(),
    showcmd(),
    filetype(),
    lineinfo(),
  })
end

function Statusline.inactive()
  return " %F"
end

function Statusline.short()
  return "%#StatusLineNC#   NETRW"
end

vim.api.nvim_exec(
  [[
  augroup Statusline
  au!
  au WinEnter,BufEnter * setlocal statusline=%!v:lua.Statusline.active()
  au WinLeave,BufLeave * setlocal statusline=%!v:lua.Statusline.inactive()
  au WinEnter,BufEnter,FileType netrw setlocal statusline=%!v:lua.Statusline.short()
  augroup END
]],
  false
)
