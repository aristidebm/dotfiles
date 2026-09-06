vim.lsp.enable({
  "pyrefly",
  "emmylua_ls",
  "nil_ls",
  "gopls",
  "harper_ls",
  "kulala_ls",
  "rust_analyzer",
  "tinymist",
  "org"  -- Experimental
})

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('my.lsp', { clear = true }),
  callback = function(event)

    local client = assert(vim.lsp.get_client_by_id(event.data.client_id))

    if client:supports_method('textDocument/definition') then
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = event.buf })
    end

    if client:supports_method('textDocument/diagnostic') then
        -- Additional diagnostic navigation
        vim.keymap.set("n", "[e", function()
          vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
        end, { desc = "Go to previous diagnostic error" })

        vim.keymap.set("n", "]e", function()
          vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
        end, { desc = "Go to next diagnostic warning" })

        vim.keymap.set("n", "[w", function()
          vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARNING })
        end, { desc = "Go to previous diagnostic error" })

        vim.keymap.set("n", "]w", function()
          vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARNING })
        end, { desc = "Go to next diagnostic warning" })
    end

    if client:supports_method('textDocument/references') then
      vim.keymap.set("n", "grr", require("fzf-lua").lsp_references, { buffer = event.buf })
    end

    -- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|
    if client:supports_method('textDocument/completion') then
      -- Optional: trigger autocompletion on EVERY keypress. May be slow!
      -- local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
      -- client.server_capabilities.completionProvider.triggerCharacters = chars
      vim.lsp.completion.enable(true, client.id, event.buf, {autotrigger = false})
    end
  end,
})

