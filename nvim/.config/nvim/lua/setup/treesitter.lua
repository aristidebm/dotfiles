require('nvim-treesitter').install {
  "go",
  "rust",
  "python",
  "lua",
  "javascript",
  "typescript",
  "templ",
}

-- 2. Register kulala_http as a custom language for nvim-treesitter (main/rewritten branch).
vim.api.nvim_create_autocmd("User", {
  pattern = "TSUpdate",
  callback = function()
    require("nvim-treesitter.parsers").kulala_http = {
      install_info = {
        url = "https://github.com/mistweaverco/tree-sitter-kulala-http",
        -- src/parser.c is pre-generated in the repo, so `generate` is not needed.
        queries = "queries/kulala_http", -- matches the parser name, copied as-is
      },
    }
  end,
})

-- 3. Use kulala for these files
-- See opts.lsp.enforce_external_script_naming_convention
-- to restrict LSP capabilities to *.http, *.http.js, *.http.ts and *.http.lua files.
vim.treesitter.language.register('kulala_http', {"http", "rest", "javascript", "lua"})

-- 4. We need to manually start treesitter for those files
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "http", "rest" },
  callback = function()
    vim.treesitter.start()
  end,
})
