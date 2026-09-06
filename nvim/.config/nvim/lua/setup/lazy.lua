local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

-- source: https://github.com/folke/lazy.nvim/discussions/1823#discussioncomment-11350684

-- require("lazy").setup("plugins")

require("lazy").setup("plugins", {
  spec = {
    { import = "plugins" },
  },
  change_detection = {
    -- enabled = false,  -- disables automatic config change detection and reloading entirely
    notify = false, -- disables just the notification about config changes
  },
})
