-- source https://github.com/nvim-lua/kickstart.nvim/blob/master/init.lua
-- See `:help cmp`
local cmp = require("cmp")
local luasnip = require("luasnip")

local enabled = true

cmp.setup({
  -- Enabled completion on demand
  enabled = enabled,
  window = {
    completion = {
      scrollbar = false,
    },
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },

  completion = {
    -- NOTE: true is not a valid value autocomplete, it is
    -- either false or a table
    -- autocomplete = false, -- disable automatic triggering
  },
  -- ignore any preselection hints provided by the language server
  preselect = require("cmp").PreselectMode.None, -- Crucial for gopls
  -- For an understanding of why these mappings were
  -- chosen, you will need to read `:help ins-completion`
  --
  -- No, but seriously. Please read `:help ins-completion`, it is really good!
  mapping = cmp.mapping.preset.insert({
    ["<C-x><C-o>"] = cmp.mapping.complete(),
    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
    -- Select the [n]ext item
    ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    --  This will auto-import if your LSP supports it.
    --  This will expand snippets if the LSP sent a snippet.

    -- <c-j> will move you to the right of each of the expansion locations.
    -- <c-k> is similar, except moving you backwards.
    ["<C-j>"] = cmp.mapping(function()
      if luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      end
    end, { "i", "s" }),
    ["<C-k>"] = cmp.mapping(function()
      if luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      end
    end, { "i", "s" }),

    -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
    --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
  }),
  sources = {
    { name = "luasnip" },
    { name = "nvim_lsp" },
    { name = "path" },
    { name = "buffer" },
    { name = "nvim_lsp_signature_help" },
    { name = "vim-dadbod-completion", priority = 700 },
  },
})

-- Add a little command to toggle completion on and off
vim.api.nvim_create_user_command("CmpToggle", function()
  enabled = not enabled
  cmp.setup.buffer({ enabled = enabled })
end, {})
