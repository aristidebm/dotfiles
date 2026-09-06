-- https://neovim.io/doc/user/lua.html#vim.filetype.add%28%29
vim.filetype.add({
  extension = {
    curl = "curl",
    http = "http",
  },
  pattern = {
    [".curl"] = "curl",
    [".http"] = "http",
    [".rest"] = "http",
  },
})

-- Don't know but this setup seems to forbid autocmd when on the top

require("options")
require("arglist")
require("path")
require("keymaps")
require("commands")
require("setup.lazy")

-- Lsp configuration

vim.lsp.enable('pyrefly')
