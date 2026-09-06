vim.api.nvim_create_user_command("ClearArglist", function()
  local arglist = vim.fn.argv()
  for i = #arglist, 1, -1 do
    if vim.fn.isdirectory(arglist[i]) == 1 then
      --- We don't want to remove the directory added to args list
      --- when launching vim with nvim <directory>
    else
      vim.cmd("argdelete " .. arglist[i])
    end
  end
  -- vim.cmd([[argdelete ##]])
end, {})
