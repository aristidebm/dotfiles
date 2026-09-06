-- An interesting source of information is https://ejmastnak.com/tutorials/vim-latex/luasnip/#install
-- Another interesting source of information https://pcoves.gitlab.io/en/blog/nvim-snippets/

local ls = require("luasnip")
local s = ls.snippet
local f = ls.function_node

ls.add_snippets("all", {
  s("genuuid", {
    f(function()
      return vim.fn.trim(vim.fn.system("uuidgen"))
    end, {}),
  }),
  s("currentdatetime", {
    f(function()
      return vim.fn.trim(vim.fn.system("date --iso-8601=s"))
    end, {}),
  }),
  s("currentdate", {
    f(function()
      return vim.fn.trim(vim.fn.system("date --iso-8601=date"))
    end, {}),
  }),
  s("currenttime", {
    f(function()
      return os.date("%H:%M:%S")
    end, {}),
  }),
})
