local grapple = require("grapple")
local fzf = require("fzf-lua")
local path = require("path")

grapple.setup({ scope = "git_branch", icons = false })

-- http://lua-users.org/wiki/StringTrim
function trim(s)
   return (s:gsub("^%s*(.-)%s*$", "%1"))
end

local function format_result(item)
 return string.format("[%s] - %s", item[1], item[2])
end

local function extract_path(repr)
  return repr:match("-%s*(.+)")
end

local function delete_tag(selected)
  if #selected > 0 then
    grapple.untag({ path = extract_path(selected[1]) })
  end
end

local function yank_path(value)
  require("clipboard").copy_to_clipboard(extract_path(value))
end

local function vsplit_file(selected, opts)
  if #selected > 0 then
    local value = {}
    table.insert(value, extract_path(selected[1]))
    fzf.actions.file_vsplit(value, opts)
  end
end

local function split_file(selected, opts)
  if #selected > 0 then
    local value = {}
    table.insert(value, extract_path(selected[1]))
    fzf.actions.file_split(value, opts)
  end
end

---@param tags grapple.tag[]
---@param current_path string
---@return integer?
local function get_current_index(tags, current_path)
	for i, tag in ipairs(tags) do
		if tag.path == current_path then
			return i
		end
	end
	return nil
end

---@param opts grapple.options
local function move_to_index(opts)
	if not opts or not opts.index then
		vim.notify("invalid options: index is required", vim.log.levels.ERROR)
		return
	end

	local current_path = vim.api.nvim_buf_get_name(0)
    if trim(current_path) == "" then
		vim.notify("cannot get the current path of the buffer", vim.log.levels.ERROR)
        return
    end

	local current_opts = { path = current_path }

	if not grapple.exists(current_opts) then
        grapple.tag(current_opts)
	end

	local tags = grapple.tags()

	local current_index = get_current_index(tags, current_path)
	if not current_index then
		vim.notify("Tag not found for the current buffer", vim.log.levels.ERROR)
		return
	end

	local new_index = opts.index
	if new_index < 0 then
		new_index = (#tags + 1) + new_index
	end

	if new_index < 1 or new_index > #tags then
		vim.notify("invalid index: Out of bounds", vim.log.levels.ERROR)
		return
	end

	if current_index == new_index then
		vim.notify("tag is already at the specified position", vim.log.levels.INFO)
		return
	end
	grapple.tag({ path = current_path, index = new_index })
	grapple.select(current_opts)
end

local function list_tags()
  -- Get the list of tags (default scope)
  local tags = grapple.tags()

  -- Map tags to display strings for fzf
  local items = {}
  for i, tag in ipairs(tags) do
      local result = {
          i,
          path.normalize_path_from_cwd(tag.path, path.getcwd()),
          (tag.cursor or { 1, 0 })[1],
          (tag.cursor or { 1, 0 })[2],
      }
    table.insert(items, result)
  end
  return items
end

local function open_grapple_tags()
  fzf.fzf_exec(
    -- https://github.com/ibhagwan/fzf-lua/wiki/Advanced
    function (fzf_cb)
      for _, item in ipairs(list_tags()) do
        fzf_cb(format_result(item))
      end
      fzf_cb() -- EOF
    end,
    {
      prompt = "Grapple❯ ",
      fzf_opts = {
        ["--reverse"] = true,
      },
      -- On selection open the file
      actions = {
        ["default"] = function(selected)
          -- Select tag by index and open
          if #selected > 0 then
            grapple.select({ path = extract_path(selected[1]) })
          end
        end,
        ["ctrl-d"] = { fn = delete_tag, reload = true },
        ["ctrl-y"] = { fn = yank_path , reload = true },
        ["ctrl-v"] = { fn = vsplit_file },
        ["ctrl-s"] = { fn = split_file },
        ["ctrl-q"] = grapple.quickfix,
      },
      -- debug = true,
    }
  )
end

-- Install this utilities for grapple https://github.com/will-lynas/grapple-utils.nvim
-- it provides moving tags
-- Map a key to open grapple tags picker with fzf-lua

vim.api.nvim_create_autocmd("FileType", {
  pattern = "grapple",
  callback = function(ev)
    local buf_id = ev.buf
    vim.schedule(function()
      -- I want the escape keybinding to close the buffer
      pcall(vim.keymap.del, "n", "<esc>", { buffer = buf_id })
    end)
  end,
})

vim.keymap.set("n", "<leader>a", grapple.tag)
vim.keymap.set("n", "<c-e>", grapple.toggle_tags)
vim.keymap.set("n", "<C-1>", function() grapple.select({ index = 1 }) end)
vim.keymap.set("n", "<C-2>", function() grapple.select({ index = 2 }) end)
vim.keymap.set("n", "<C-3>", function() grapple.select({ index = 3 }) end)
vim.keymap.set("n", "<C-4>", function() grapple.select({ index = 4 }) end)
