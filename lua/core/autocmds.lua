-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Zellij opens scrollback in a temporary dump and marks it through the
-- wrapper in dotfiles/scripts/zellij-scrollback-nvim. Keep these mappings
-- buffer-local so ordinary Neovim buffers are unaffected.
local zellij_scrollback_group = vim.api.nvim_create_augroup('user-zellij-scrollback', { clear = true })

local function is_zellij_scrollback(bufnr)
  return vim.env.DOTFILES_ZELLIJ_SCROLLBACK == '1' and vim.api.nvim_buf_get_name(bufnr):match '%.dump$' ~= nil
end

local function close_zellij_scrollback()
  vim.cmd 'qa!'
end

local function configure_zellij_scrollback(args)
  local bufnr = args.buf
  if not is_zellij_scrollback(bufnr) or vim.b[bufnr].zellij_scrollback_configured then
    return
  end

  vim.b[bufnr].zellij_scrollback_configured = true
  vim.bo[bufnr].buflisted = false
  vim.bo[bufnr].swapfile = false
  vim.bo[bufnr].undofile = false
  vim.bo[bufnr].modifiable = false
  vim.bo[bufnr].readonly = true

  vim.keymap.set('x', 'y', function()
    vim.cmd 'normal! y'
    vim.fn.setreg('+', vim.fn.getreg '"')
    close_zellij_scrollback()
  end, { buffer = bufnr, silent = true, desc = 'Yank scrollback and close' })

  -- Keep Visual mode's first Esc available to leave the selection. A second
  -- Esc in Normal mode cancels the temporary editor and restores the pane.
  vim.keymap.set('x', '<Esc>', '<Esc>', {
    buffer = bufnr,
    silent = true,
    desc = 'Leave scrollback Visual mode',
  })
  vim.keymap.set('n', '<Esc>', close_zellij_scrollback, {
    buffer = bufnr,
    silent = true,
    desc = 'Cancel scrollback editor',
  })

  -- Vim's +LINE command-line argument has already positioned the cursor by
  -- VimEnter/BufEnter time; schedule the mode switch after those events.
  vim.schedule(function()
    if vim.api.nvim_buf_is_valid(bufnr) and vim.api.nvim_get_current_buf() == bufnr then
      vim.cmd 'normal! v'
    end
  end)
end

vim.api.nvim_create_autocmd({ 'BufEnter', 'VimEnter' }, {
  desc = 'Enable Visual mode for Zellij scrollback',
  group = zellij_scrollback_group,
  callback = configure_zellij_scrollback,
})

-- Restore cursor to last known position when reopening a file
vim.api.nvim_create_autocmd('BufReadPost', {
  desc = 'Restore cursor to last known position',
  group = vim.api.nvim_create_augroup('user-restore-cursor', { clear = true }),
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local lcount = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, { mark[1], mark[2] })
      vim.cmd('normal! zv')
    end
  end,
})

-- Check for external file changes on focus gain or cursor hold
vim.api.nvim_create_autocmd({ 'FocusGained', 'CursorHold' }, {
  desc = 'Check for external file changes',
  group = vim.api.nvim_create_augroup('user-auto-reload', { clear = true }),
  callback = function()
    if vim.fn.getcmdwintype() == '' then
      vim.cmd('checktime')
    end
  end,
})
