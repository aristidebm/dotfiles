-- local Menu = require("org-modern.menu")
require('orgmode').setup({
  org_agenda_files = '~/Documents/Notes/personal/**/*',
  org_default_notes_file = '~/Documents/Notes/personal/refile.org',
  mappings = {
    disable_all = true
  }
  -- ui = {
  --   menu = {
  --     handler = function(data)
  --       Menu:new():open(data)
  --     end,
  --   },
  -- }
})

require("org-bullets").setup({
    concealcursor = false, -- If false then when the cursor is on a line underlying characters are visible
    symbols = {
      -- list symbol
      list = "•",
      -- headlines can be a list
      headlines = { "◉", "○", "✸", "✿" },
      -- or a function that receives the defaults and returns a list
      headlines = function(default_list)
        table.insert(default_list, "♥")
        return default_list
      end,
      -- or false to disable the symbol. Works for all symbols
      headlines = false,
      -- or a table of tables that provide a name
      -- and (optional) highlight group for each headline level
      headlines = {
        { "◉", "MyBulletL1" },
        { "○", "MyBulletL2" },
        { "✸", "MyBulletL3" },
        { "✿", "MyBulletL4" },
      },
      checkboxes = {
        half = { "", "@org.checkbox.halfchecked" },
        done = { "✓", "@org.keyword.done" },
        todo = { "˟", "@org.keyword.todo" },
      },
    }
  })


vim.api.nvim_create_autocmd('FileType', {
  pattern = 'org',
  callback = function()
    vim.keymap.set('i', '<M-CR>', '<cmd>lua require("orgmode").action("org_mappings.meta_return")<CR>', {
      silent = true,
      buffer = true,
    })
  end,
})

vim.keymap.set("n", "<leader>oa", function()
  require("orgmode").action("org_agenda")
end, { desc = "[O]rg [A]genda" })

vim.keymap.set("n", "<leader>oc", function()
  require("orgmode").action("org_capture")
end, { desc = "[O]rg [C]apture" })

vim.keymap.set("n", "<leader>ot", function()
  require("orgmode").action("org_mappings.org_time_stamp")
end, { desc = "[O]rg [T]imestamp" })

vim.keymap.set("n", "<leader>ox", function()
  require("orgmode").action("org_mappings.export")
end, { desc = "[O]rg e[x]port" })
