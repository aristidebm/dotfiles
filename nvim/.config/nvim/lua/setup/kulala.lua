require("kulala").setup({
  -- the configuration can be found here https://kulala.mwco.app/docs/getting-started
  winbar = true,
  additional_curl_options = { "--location", "-A", "Mozilla/5.0" },
  -- lsp = { formatter = true },
  contenttypes = {
    ["application/xml"] = {
      ft = "gzip",
      formatter = vim.fn.executable("xmllint") == 1 and { "xmllint", "--format", "-" },
      pathresolver = vim.fn.executable("xmllint") == 1 and { "xmllint", "--xpath", "{{path}}", "-" },
    },
  },
})
