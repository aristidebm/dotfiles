vim.g.completion_enabled = true -- blink is enabled by default now that auto_show handles "out of the way"

require("blink.cmp").setup({

  enabled = function()
    local buf_val = vim.b.completion_enabled
    if buf_val ~= nil then
      -- buffer explicitly set (true or false) overrides global
      return buf_val
    end
    return vim.g.completion_enabled or false
  end,

  signature = { enabled = true },
  -- This line is import for it to work
  snippets = { preset = "luasnip" },

  completion = {
    menu = {
      auto_show = false, -- never pop up automatically while typing
      scrollbar = false,
    },
    list = {
      selection = {
        preselect = true,   -- highlight first match automatically (default, shown for clarity)
        auto_insert = true, -- insert its text as a live preview (default, shown for clarity)
      },
    },
  },

  cmdline = {
    -- Disable cmdline completions
    enabled = false
  },
  keymap = {
    preset = "default",
    --
    -- Disable C-k
    ["<C-k>"] = {},

    ["<C-n>"] = {
      function(cmp)
        if cmp.is_visible() then
          return cmp.select_next()
        else
          return cmp.show_and_insert_or_accept_single()
        end
      end,
      "fallback",
    },
    ["<C-p>"] = {
      function(cmp)
        if cmp.is_visible() then
          return cmp.select_prev()
        else
          return cmp.show_and_insert_or_accept_single()
        end
      end,
      "fallback",
    },
  },
  appearance = {
    -- use_nvim_cmp_as_default = true,
    nerd_font_variant = "mono",
  },

  sources = {
    default = { "buffer", "lsp", "snippets", "path" },
    providers = {
      -- source https://github.com/kristijanhusak/vim-dadbod-completion?tab=readme-ov-file#install
      dadbod = {
        name = "Dadbod",
        module = "vim_dadbod_completion.blink",
      },
      lsp = {
        score_offset = 10,
      },
      buffer = {
        score_offset = 9,
      },
      path = {
        score_offset = 5,
      },
      snippets = {
        score_offset = 5,
      },
    },
    per_filetype = {
       -- https://github.com/Saghen/blink.cmp/issues/475
      -- add vim-dadbod-completion to your completion providers
      sql = { "lsp", "path", "snippets", "buffer", "dadbod" },
      mysql = { "lsp", "path", "snippets", "buffer", "dadbod" },
      plsql = { "lsp", "path", "snippets", "buffer", "dadbod" },
    },
  },
})

-- Toggle completion for the CURRENT buffer only
local function toggle_buffer_completion()
  local current = vim.b.completion_enabled
  if current == nil then
    current = vim.g.completion_enabled or false
  end
  vim.b.completion_enabled = not current
  vim.notify("Completion (buffer): " .. tostring(vim.b.completion_enabled))
end

-- Toggle completion GLOBALLY (buffers with an explicit local override keep their own state)
local function toggle_global_completion()
  vim.g.completion_enabled = not (vim.g.completion_enabled or false)
  vim.notify("Completion (global): " .. tostring(vim.g.completion_enabled))
end

vim.opt.completeopt = "menu,menuone"

vim.api.nvim_create_user_command("BlinkBufferToggle", toggle_buffer_completion, {})
vim.api.nvim_create_user_command("BlinkGlobalToggle", toggle_global_completion, {})
