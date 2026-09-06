local dap = require("dap")

-- An interesting https://tamerlan.dev/a-guide-to-debugging-applications-in-neovim/
-- local dapui = require("dapui")

require("mason-nvim-dap").setup({
  -- Makes a best effort to setup the various debuggers with
  -- reasonable debug configurations
  automatic_setup = true,

  -- You can provide additional configuration to the handlers,
  -- see mason-nvim-dap README for more information
  handlers = {},

  -- You'll need to check that you have the required things installed
  -- online, please don't ask me how to install them :)
  ensure_installed = {
    -- Update this to ensure that you have the debuggers for the langs you want
    "delve",
    "debugpy",
  },
})

require("nvim-dap-virtual-text").setup({})

local dapview = require("dap-view")
dapview.setup({
  -- for more information check this https://github.com/igorlfs/nvim-dap-view/blob/main/lua/dap-view/config.lua
  winbar = {
    controls = {
      enabled = true,
    },
  },
  windows = {
    height = 10,
    position = "below",
    terminal = {
      position = "left",
      -- https://github.com/igorlfs/nvim-dap-view/blob/280213aa7a553c03fccf97771e340f991706478c/docs/src/posts/hide-terminal.md?plain=1#L6
      hide = { "go", "python" },
      width = 0.5,
      -- enable to not show the terminal on start
      start_hidden = false,
    },
  },
})

-- customize signs
-- vim.fn.sign_define('DapBreakpoint', {text='', texthl='', linehl='', numhl=''})
-- to see all available values of highlight just do :highlight
vim.fn.sign_define("DapBreakpoint", { texthl = "Constant" })

-- Basic debugging keymaps, feel free to change to your liking!
vim.keymap.set("n", "<leader>dt", dapview.toggle, { desc = "[D]ebugger [T]oggle" })
vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "[D]ebugger [C]ontinue" })
vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "[D]ebugger Step [I]nto" })
vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "[D]ebugger Step [O]ver" })
vim.keymap.set("n", "<leader>du", dap.step_out, { desc = "[D]ebugger Step O[U]t" })
vim.keymap.set("n", "<leader>dq", function()
  dap.terminate()
  require("nvim-dap-virtual-text").toggle()
  dapview.toggle()
end, { desc = "[D]ebugger [Q]uit" })
vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "[D]ebugger [B]reakpoint" })
vim.keymap.set("n", "<leader>de", function()
  dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "[D]ebugger [E]xpression" })

-- -- Dap UI setup
-- -- For more information, see |:help nvim-dap-ui|
-- dapui.setup({
-- 	-- Set icons to characters that are more likely to work in every terminal.
-- 	--    Feel free to remove or use ones that you like more! :)
-- 	--    Don't feel like these are good choices.
-- 	icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
-- 	controls = {
-- 		icons = {
-- 			pause = "",
-- 			play = "",
-- 			step_into = "",
-- 			step_over = "",
-- 			step_out = "",
-- 			step_back = "",
-- 			run_last = "",
-- 			terminate = "",
-- 			disconnect = "",
-- 		},
-- 	},
-- })
--
--
-- -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
-- vim.keymap.set("n", "<F7>", dapui.toggle, { desc = "Debug: See last session result." })
--
-- dap.listeners.after.event_initialized["dapui_config"] = dapui.open
-- dap.listeners.before.event_terminated["dapui_config"] = dapui.close
-- dap.listeners.before.event_exited["dapui_config"] = dapui.close

-- Install golang specific config
require("dap-go").setup({})

-- Install python specific config
local debugpy = require("dap-python")
debugpy.test_runner = "pytest"
debugpy.setup(os.getenv("HOME") .. "/.local/share/nvim/mason/packages/debugpy/venv/bin/python")
-- table.insert(require('dap').configurations.python, {
--   type = 'python',
--   request = 'launch',
--   name = 'My custom launch configuration',
--   program = '${file}',
--   -- ... more options, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings
-- })
