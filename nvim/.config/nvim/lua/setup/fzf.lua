local actions = require("fzf-lua").actions

require("fzf-lua").setup({
  "ivy",
  grep = {
    -- do no inherit actions from 'actions.files' and merge
    false,
    prompt = "Grep❯ ",
    header = false,
    hidden = true,
  },
  files = {
    -- do no inherit actions  from 'actions.files' and merge
    false,
    header = false,
    actions = {
      ["ctrl-y"] = { fn = require("clipboard").copy_to_clipboard, reload = true }
    },
    -- no_ignore          = true
  },
  args = {
    -- do no inherit actions  from 'actions.files' and merge
    false,
    prompt = "Args❯ ",
    files_only = true,
    header = false,
    actions = {
      ["ctrl-x"] = false,
      ["ctrl-d"] = { fn = actions.arg_del, reload = true },
      ["ctrl-y"] = { fn = require("clipboard").copy_to_clipboard, reload = true }
    },
  },
  buffers = {
    prompt = "Buffers❯ ",
    -- actions inherit from 'actions.files' and merge
    actions = {
      ["ctrl-x"] = false,
      ["ctrl-d"] = { fn = actions.arg_del, reload = true }
    },
  },
  fzf_colors = {
    -- true,
    -- make gutter color and current line background color match
    -- the terminal color
    ["bg"] = "-1",
    ["bg+"] = "-1",
    ["gutter"] = "-1",
  },
  -- override telescope preset fzf_opts
  fzf_opts = {
    ["--layout"] = "reverse",
    ["--cycle"] = false,
    ["--no-separator"] = true,
  },
  -- Show additional information on each entry right
  -- defaults = { formatter = 'path.filename_first' },
  -- winopts = {
  --   width = 0.9,
  --   border = "single",
  --   preview = {
  --     hidden = "hidden",
  --     scrollbar = "none",
  --     border = "single",
  --   },
  -- },
  keymap = {
    builtin = {
      -- nvim registers <C-/> as <C-_>, use insert mode
      -- and press <C-v><C-/> should output ^_
      -- NOTE: This is important for ctrl-/ binding to work in fzf table
      -- below
      ["<C-_>"] = "toggle-preview",
    },
    fzf = {
      -- fzf binary commands prefix (you can check here https://github.com/junegunn/fzf/blob/d938fdc496ccecfe5d747500927b675d31e1835a/src/options.go#L1390a for more context)
      ["ctrl-q"] = "select-all+accept",
      ["ctrl-/"] = "toggle-preview",
      ["change"] = "top",
    },
  },
})

-- register fzf-lua as the UI interface for vim.ui.select h :vim.ui.select
require("fzf-lua").register_ui_select()

-- utilities
function noop()
end

local function find_or_create_file(opts)
  opts = opts or {}
  local cwd = opts.cwd or vim.fn.getcwd()

  require("fzf-lua").fzf_exec("ls -la " .. vim.fn.shellescape(cwd), {
    prompt = "Files> ",
    cwd = cwd,
    fzf_opts = {
      ["--print-query"] = true,
      ["--header-lines"] = "1", -- skip the "total N" line ls prints first
    },
    actions = {
      ["default"] = function(selected, o)
        local query = o.last_query
        if selected and selected[1] and selected[1] ~= "" then
          -- ls -la output: permissions owner group size date date date filename
          -- filename is everything after the 8th whitespace-separated field
          local filename = selected[1]:match("^%s*%S+%s+%S+%s+%S+%s+%S+%s+%S+%s+%S+%s+%S+%s+%S+%s+(.+)$")
          if filename then
            vim.cmd("edit " .. vim.fn.fnameescape(cwd .. "/" .. filename))
          end
        elseif query and query ~= "" then
          vim.cmd("edit " .. vim.fn.fnameescape(cwd .. "/" .. query))
        end
      end,
    },
  })
end

-- Find keymaps

vim.keymap.set("n", "<leader>ff", function()
    require("fzf-lua").files({
        cwd_prompt = false,
        prompt = "Files> ",
        header = false,
    })
    end,
{ desc = "[F]ind [F]ile" })
vim.keymap.set("n", "<leader>fn", function()
    require("fzf-lua").files({
        cwd_prompt = false,
        prompt = "Notes> ",
        header = false,
        cwd = "~/Documents/Notes/",
        fd_opts = [[--color=never --type f --type l --glob "*.{md,org}" --exclude .git --exclude .jj]],
    })
    end,
{ desc = "[F]ind [N]ote" })

vim.keymap.set("n", "<leader>fc", function()
    local config_dir = vim.fn.stdpath("config")
    vim.cmd.lcd(config_dir)
    vim.cmd.edit(config_dir .. "/init.lua")
end,
   { desc = "[F]ind [C]onfig"}
)

vim.keymap.set("n", "<leader>fs", function()
  vim.cmd.edit(vim.fn.stdpath("data") .. "/scratch.md")
  end,
{ desc = "[F]ind [S]cratch" })
vim.keymap.set("n", "<leader>fb", require("fzf-lua").buffers, { desc = "[F]ind [B]uffer" })
vim.keymap.set("n", "<leader>fa", require("fzf-lua").args, { desc = "[F]ind [A]rgument" })
vim.keymap.set("n", "<leader>fr", require("fzf-lua").oldfiles, { desc = "[F]ind [R]ecent" })

-- Search keymaps

vim.keymap.set("n", "<leader>sa", noop, { desc = "[S]earch [A]rguments" })
vim.keymap.set("n", "<leader>sb", noop, { desc = "[S]earch [B]uffers" })
vim.keymap.set("n", "<leader>ss", noop, { desc = "[S]earch [S]ymbols" })
-- vim.keymap.set("n", "<leader>sb", require("fzf-lua").lines, { desc = "[S]earch [B]uffers" })
vim.keymap.set("n", "<leader>sr", noop, { desc = "[S]earch [R]ecent" })
-- vim.keymap.set("n", "<leader>sr", require("fzf-lua").resume, { desc = "[S]earch [R]ecent" })
vim.keymap.set("n", "<leader>sf", require("fzf-lua").grep, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>sd", require("fzf-lua").diagnostics_workspace, { desc = "[S]earch [D]iagonistics" })
vim.keymap.set("n", "<leader>st", function()
    require("todo-comments.fzf").todo({ prompt = "Todos> " })
end, { desc = "[S]earch [T]odos" })
vim.keymap.set("n", "<leader>sc", require("fzf-lua").commands, { desc = "[S]earch [C]ommands" })
vim.keymap.set("n", "<leader>sm", require("fzf-lua").manpages, { desc = "[S]earch [M]anual" })
vim.keymap.set("n", "<leader>sh", require("fzf-lua").help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sw", require("fzf-lua").grep_cword, { desc = "[S]earch [W]ord" })
vim.keymap.set("v", "<leader>sw", require("fzf-lua").grep_visual, { desc = "[S]earch [W]ord" })
vim.keymap.set("n", "<leader>sW", require("fzf-lua").grep_cWORD, { desc = "[S]earch [W]ord" })

-- Quickfix keymaps
vim.keymap.set("n", "<leader>ql", require("fzf-lua").quickfix, { desc = "Quickfix" })
vim.keymap.set("n", "<leader>qs", require("fzf-lua").quickfix_stack, { desc = "[Q]uick [S]tack" })
