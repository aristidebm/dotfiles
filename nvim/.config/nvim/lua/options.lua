-- Use space as my leader key
vim.g.mapleader = " "

-- Remove cursor blinking stuff in pickers.
-- vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50"

-- Activate block cursor for all modes
-- vim.opt.guicursor = ""

-- Show me line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Don't backup please
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

-- Highlight syntax please
vim.cmd("syntax on")

-- Be smart about my indentation
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.smarttab = true

-- Highlight automatically when searching, but don't highlight all
-- occurrences.
vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.completeopt="menu,menuone"

-- Use my amazing terminal colors.
vim.opt.termguicolors = true

-- Show the cursor line
vim.opt.cursorline = true
-- This line is important since it let us
-- disable the highlighting of the cursor line
-- and only highlight line number even if
-- cursorline is set https://vi.stackexchange.com/a/28005
-- help cursorlineopt to see available options
vim.opt.cursorlineopt = "number"

vim.opt.scrolloff = 0 -- zt and zb are handy

-- Case-insensitive searching UNLESS \C is present in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Network-w (netrw)
---Removes banner that contains help page and all.
vim.g.netrw_banner = 0
vim.g.netrw_localcopydircmd = "cp -r"

--- Only and only one status line no matter what
vim.opt.laststatus = 3

-- Align split windows on the right
vim.opt.splitright = true

-- Do not wrap test
vim.opt.wrap = false

-- prevent gutter jumping (don't forget, you can always hit :h signcolumn
-- for more information)
vim.opt.signcolumn = "yes:1"

-- Let :grep respect .gitignore
vim.opt.grepprg = "rg --vimgrep --hidden"

-- Show whitespace.
vim.opt.list = false
vim.opt.listchars = {
  -- tab = "→-" }
  tab = "»-",
  trail = "-",
  nbsp = "+",
  eol = "↲",
  space = "·",
}

vim.diagnostic.config({ virtual_text = true })

-- vim.wo.foldmethod = 'expr'
-- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.winborder = "rounded"

-- override search highliight
vim.api.nvim_set_hl(0, "Search", { bg = "#8BB7C7", fg = "#000000", bold = true })
