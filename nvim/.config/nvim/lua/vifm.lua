local function open_vifm(layout)
  if vim.fn.executable('vifm') == 0 then
    vim.notify('vifm is not executable', vim.log.levels.ERROR)
    return
  end

  -- 1. Directory to start in: the current file's directory, else the cwd
  local dir = vim.uv.cwd()
  local name = vim.api.nvim_buf_get_name(0)
  if vim.bo.buftype == '' and name ~= '' then
    local candidate = vim.fs.dirname(name)
    local stat = candidate and vim.uv.fs_stat(candidate)
    if stat and stat.type == 'directory' then
      dir = candidate
    end
  end

  -- 2. Remember what to go back to if Vifm is quit without a selection
  local prev_buf = vim.api.nvim_get_current_buf()
  local is_split = layout == 'vsplit' or layout == 'split'

  -- 3. Always host Vifm in a fresh buffer
  if is_split then
    vim.cmd(layout)
  end
  vim.cmd.enew()

  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_get_current_buf()
  vim.bo[buf].bufhidden = 'wipe'

  -- 4. Reclaim the screen: no statusline row, no command-line row, no mode
  --    message. Set before jobstart so the pty gets the full height.
  local saved = {
    showmode = vim.o.showmode,
    laststatus = vim.o.laststatus,
    cmdheight = vim.o.cmdheight,
  }
  vim.o.showmode = false
  vim.o.laststatus = 0
  vim.o.cmdheight = 0

  local group = vim.api.nvim_create_augroup('VifmChrome' .. buf, { clear = true })
  local function hide_winbar()
    if vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_buf(win) == buf then
      vim.wo[win].winbar = ''
    end
  end
  hide_winbar()
  vim.api.nvim_create_autocmd({ 'BufWinEnter', 'WinEnter', 'TermEnter' }, {
    group = group,
    buffer = buf,
    callback = hide_winbar,
  })

  local choose_file = vim.fn.tempname()

  -- 5. Launch Vifm (Nvim 0.11+: jobstart with term = true)
  vim.fn.jobstart({ 'vifm', '--choose-files', choose_file }, {
    term = true,
    cwd = dir,
    on_exit = function()
      vim.schedule(function()
        pcall(vim.api.nvim_del_augroup_by_id, group)
        vim.o.showmode = saved.showmode
        vim.o.laststatus = saved.laststatus
        vim.o.cmdheight = saved.cmdheight

        local files = {}
        if vim.fn.filereadable(choose_file) == 1 then
          files = vim.tbl_filter(function(l) return l ~= '' end, vim.fn.readfile(choose_file))
        end
        vim.fn.delete(choose_file)

        if not vim.api.nvim_win_is_valid(win) then
          return
        end

        -- Give the window its normal winbar back
        vim.api.nvim_win_call(win, function()
          vim.cmd('setlocal winbar<')
        end)

        if #files == 0 then
          -- Cancelled: undo the layout change
          if is_split and #vim.api.nvim_tabpage_list_wins(0) > 1 then
            vim.api.nvim_win_close(win, true)
          elseif vim.api.nvim_buf_is_valid(prev_buf) then
            vim.api.nvim_win_set_buf(win, prev_buf)
          end
          return
        end

        vim.api.nvim_set_current_win(win)
        vim.cmd('edit ' .. vim.fn.fnameescape(files[1]))
        for i = 2, #files do
          vim.cmd('vsplit ' .. vim.fn.fnameescape(files[i]))
        end
      end)
    end,
  })

  vim.cmd.startinsert()
end

vim.keymap.set('n', '-', function() open_vifm('edit') end, { desc = 'Vifm (Current Window)' })
vim.keymap.set('n', '<leader>vv', function() open_vifm('edit') end, { desc = 'Vifm (Current Window)' })
vim.keymap.set('n', '<leader>vs', function() open_vifm('vsplit') end, { desc = 'Vifm (Vertical Split)' })
vim.keymap.set('n', '<leader>vh', function() open_vifm('split') end, { desc = 'Vifm (Horizontal Split)' })
