-- set the cursor to be block
-- vim.opt.guicursor = ""

-- Show me line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Don't backup please
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

-- Highlight please
-- vim.cmd("syntax off")

-- Be smart about my indentation
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Highlight automatically when searching, but don't highlight all
-- occurrence.
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Use my amazing terminal colors.

vim.opt.termguicolors = true

-- Draw column
-- vim.opt.colorcolumn = "80"

-- Do not wrap test
vim.opt.wrap = false

-- Keep at least 8 lines above and below my cursor.
vim.opt.scrolloff = 0 -- zt and zb are kind of handy

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Use space as my leader key
vim.g.mapleader = " "

-- Network-w (netrw)
---Removes banner that contains help page and all.
vim.g.netrw_banner = 0
vim.g.netrw_localcopydircmd = "cp -r"

vim.opt.laststatus = 3

-- Let :grep respect .gitignore
vim.opt.grepprg = "rg --vimgrep"

-- fallback to vim default colorsheme, the neovim one, is just annoying
vim.cmd("colorscheme vim")
