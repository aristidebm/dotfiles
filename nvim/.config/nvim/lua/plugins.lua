return {
  {
    "nvim-lua/plenary.nvim",
    tag = "v0.1.3",
    pin = true,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    tag = "v0.9.3",
    pin = true,
    config = function()
      require("setup.treesitter")
    end,
  },
  {
    "mbbill/undotree",
    pin = true,
    tag = "rel_6.1",
    config = function()
      require("setup.undotree")
    end,
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
  },
  {
    "michaelrommel/nvim-silicon",
    lazy = true,
    cmd = "Silicon",
    config = function()
      require("setup.silicon")
    end,
  },
  {
    "stevearc/oil.nvim",
    config = function()
      require("setup.oil")
    end,
  },
  {
    "FabijanZulj/blame.nvim",
    lazy = false,
    config = function()
      require("setup.git")
    end,
  },
  {
    "ibhagwan/fzf-lua",
    config = function()
      require("setup.fzf")
    end,
  },
  {
    -- Main LSP Configuration
    "neovim/nvim-lspconfig",
    config = function()
      require("setup.lsp")
    end,
  },
  -- { -- Autocompletion
  --   "hrsh7th/nvim-cmp",
  --   event = "InsertEnter",
  --   dependencies = {
  --     {
  --       "L3MON4D3/LuaSnip",
  --       -- follow latest release.
  --       version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
  --       -- optional: provides snippets for the snippet source
  --       -- dependencies = 'rafamadriz/friendly-snippets',
  --       config = function()
  --         require("setup.luasnip")
  --       end,
  --     },
  --     -- Adds other completion capabilities.
  --     --  nvim-cmp does not ship with all sources by default. They are split
  --     --  into multiple repos for maintenance purposes.
  --     "hrsh7th/cmp-nvim-lsp",
  --     "hrsh7th/cmp-path",
  --     "hrsh7th/cmp-nvim-lsp-signature-help",
  --     "hrsh7th/cmp-buffer",
  --     "saadparwaiz1/cmp_luasnip",
  --   },
  --   config = function()
  --     require("setup.cmp")
  --   end,
  -- },
  {
    'saghen/blink.cmp',
    -- use a release tag to download pre-built binaries
    version = '1.*',
    dependencies = {
      'L3MON4D3/LuaSnip',
      version = 'v2.*',
      config = function()
           require("setup.luasnip")
       end
    },
    config = function()
      require("setup.blink")
    end,
  },
  {
    "mistweaverco/kulala.nvim",
    lazy = true,
    ft = { "http", "rest" },
    config = function()
      require("setup.kulala")
    end,
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({})
    end,
  },
  -- {
  --   "ludovicchabant/vim-gutentags",
  --   config = function() end,
  -- },
  {
    "cbochs/grapple.nvim",
    config = function()
      require("setup.grapple")
    end,
  },
  -- {
  --   "miikanissi/modus-themes.nvim",
  --   priority = 1000,
  --   config = function()
  --     require("modus-themes").setup({
  --
  --       style = "modus_operandi", -- Always use modus_operandi regardless of `vim.o.background`
  --
  --       variants = {
  --         -- modus_operandi = "deuteranopia", -- Use deuteranopia variant for `modus_operandi`
  --         modus_vivendi = "tinted", -- Use tinted variant for `modus_vivendi`
  --       },
  --
  --       styles = {
  --         functions = { italic = true }, -- Enable italics for functions
  --       },
  --
  --       on_colors = function(colors)
  --         colors.error = colors.red_faint -- Change error color to the "faint" variant
  --       end,
  --
  --       on_highlights = function(highlight, color)
  --         highlight.Boolean = { fg = color.green } -- Change Boolean highlight to use the green color
  --       end,
  --   })
  --
  --   vim.cmd.colorscheme("modus")
  --
  --   end
  -- },
  {
    "vague-theme/vague.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other plugins
    config = function()
      require("vague").setup({
        transparent = true,
        -- optional configuration here
        -- on_highlights = function(hl, c)
        --   hl.Search = { bg = "#8BB7C7" }  -- Sets background to your desired color
        -- end,
         on_highlights = function(hl, c)
          -- Make search highlighting more visible
          -- hl.IncSearch: The match while typing the search
          -- Also update incremental search highlighting
          hl.IncSearch = {
            fg = "#000000",
            bg = "#8BB7C7",
            bold = true,
          }
        end,
      })
      vim.cmd.colorscheme("vague")
    end,
  },
--   {
--     "zenbones-theme/zenbones.nvim",
--     -- Optionally install Lush. Allows for more configuration or extending the colorscheme
--     -- If you don't want to install lush, make sure to set g:zenbones_compat = 1
--     -- In Vim, compat mode is turned on as Lush only works in Neovim.
--     dependencies = "rktjmp/lush.nvim",
--     lazy = false,
--     priority = 1000,
--     -- you can set set configuration options here
--     config = function()
--         vim.g.zenbones_darken_comments = 45
--         vim.cmd.colorscheme('zenbones')
--     end
-- },
  {
    -- NOTE: https://github.com/davesavic/dadbod-ui-yank allow to yank results in different format
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      require("setup.dadbod")
    end,
  },
  {
    "tpope/vim-fugitive",
    config = function()
      -- require("setup.fugitive")
    end,
  },
  {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  opts = {
    indent = { char = "│" },  -- or "▏", "┊", etc.
    scope = {
      -- highlights current scope
      enabled = true,
      -- remove the underlines
      show_start = false,
      show_end = false,
    },
  },
 },
 { "Bekaboo/dropbar.nvim",
   opts = {
     bar = {
       sources = function(buf, _)
        local sources = require('dropbar.sources')
        local utils = require('dropbar.utils')
        if vim.bo[buf].ft == 'markdown' then
          return {
            sources.path,
            sources.markdown,
          }
        end
        if vim.bo[buf].buftype == 'terminal' then
          return {
            sources.terminal,
          }
        end
        return {
          -- sources.path,
          utils.source.fallback({
            sources.lsp,
            sources.treesitter,
          }),
        }
    end
   }
  }
 },
 {
  'nvim-orgmode/orgmode',
  event = 'VeryLazy',
  ft = { 'org' },
  dependencies = {
    "akinsho/org-bullets.nvim"
  },
  config = function()
    require("setup.org")
  end,
 }
}
