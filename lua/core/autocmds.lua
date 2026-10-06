local group = vim.api.nvim_create_augroup('kali-minimal', { clear = true })

vim.api.nvim_create_autocmd('TextYankPost', {
  group = group,
  desc = 'Highlight yanked text',
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.api.nvim_create_autocmd('BufReadPost', {
  group = group,
  desc = 'Restore cursor position',
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, { mark[1], mark[2] })
    end
  end,
})

vim.api.nvim_create_autocmd({ 'FocusGained', 'CursorHold' }, {
  group = group,
  desc = 'Check for external file changes',
  callback = function()
    if vim.fn.getcmdwintype() == '' then
      vim.cmd 'checktime'
    end
  end,
})
