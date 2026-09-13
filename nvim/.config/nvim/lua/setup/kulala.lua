require("kulala").setup({
  -- the configuration can be found here https://kulala.mwco.app/docs/getting-started
  winbar = true,
  additional_curl_options = { "--location", "-A", "Mozilla/5.0" },
  contenttypes = {
    ["application/xml"] = {
      ft = "gzip",
      formatter = vim.fn.executable("xmllint") == 1 and { "xmllint", "--format", "-" },
      pathresolver = vim.fn.executable("xmllint") == 1 and { "xmllint", "--xpath", "{{path}}", "-" },
    },
  },
  treesitter = {
    -- for a reason I don't know I ended up ia wiered stated where
    -- https://github.com/mistweaverco/tree-sitter-kulala-http is fetched
    -- from github to my machine but the remote hasn't be set on that repo
    -- so when opening an *.http file I get
    -- "Failed to fetch tree-sitter grammar: fatal: 'origin' does not appear to be a git repository fatal: Could not read from remote repository."
    -- So I have decided to manage it myself inside setup/treesitter.lua
    enable = false,
    -- path to tree-sitter CLI, if not in PATH
    -- if enable is false, this is not used
    -- required for building the parser from the included grammar
    cli_path = "tree-sitter",
  },
})
