vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })
vim.keymap.set('n', ';', ':', { desc = 'Enter command mode' })
vim.keymap.set('n', '<leader>b', '<cmd>enew<CR>', { desc = 'New buffer' })

vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!"<CR>')

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move to left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move to right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move to lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move to upper window' })

vim.keymap.set('n', '<leader>ty', '<cmd>tabnew<CR>', { desc = 'New tab' })
vim.keymap.set('n', '<leader>tn', '<cmd>tabnext<CR>', { desc = 'Next tab' })
vim.keymap.set('n', '<leader>tp', '<cmd>tabprevious<CR>', { desc = 'Previous tab' })
vim.keymap.set('n', '<leader>tc', '<cmd>tabclose<CR>', { desc = 'Close tab' })
vim.keymap.set('n', '<leader>to', '<cmd>tabonly<CR>', { desc = 'Keep only this tab' })
vim.keymap.set('n', '<leader>tm', '<cmd>tabmove<CR>', { desc = 'Move tab' })

local function tab_buffers()
  return _G.TabScopedBuffers
end

vim.keymap.set('n', '<Tab>', function()
  if tab_buffers() then
    tab_buffers().next_buffer()
  end
end, { desc = 'Next buffer in tab' })
vim.keymap.set('n', '<S-Tab>', function()
  if tab_buffers() then
    tab_buffers().prev_buffer()
  end
end, { desc = 'Previous buffer in tab' })

for index = 1, 9 do
  vim.keymap.set('n', '<leader>' .. index, function()
    if tab_buffers() then
      tab_buffers().goto_buffer(index)
    end
  end, { desc = 'Go to buffer ' .. index })
end

vim.keymap.set('n', '<leader>bc', function()
  if tab_buffers() then
    tab_buffers().close_buffer()
  end
end, { desc = 'Close buffer' })
vim.keymap.set('n', '<leader>bn', function()
  if tab_buffers() then
    tab_buffers().next_buffer()
  end
end, { desc = 'Next buffer' })
vim.keymap.set('n', '<leader>bp', function()
  if tab_buffers() then
    tab_buffers().prev_buffer()
  end
end, { desc = 'Previous buffer' })
