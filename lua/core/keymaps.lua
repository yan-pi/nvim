-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- Tab management (native Neovim tabpages - different workspaces/contexts)
-- Each tab has its own isolated set of buffers (like browser tabs or IDE workspaces)
vim.keymap.set('n', '<leader>ty', '<cmd>tabnew<cr>', { desc = '[T]ab New workspace ([Y])' })
vim.keymap.set('n', '<leader>tn', '<cmd>tabnext<cr>', { desc = '[T]ab [N]ext workspace' })
vim.keymap.set('n', '<leader>tp', '<cmd>tabprevious<cr>', { desc = '[T]ab [P]revious workspace' })
vim.keymap.set('n', '<leader>tc', '<cmd>tabclose<cr>', { desc = '[T]ab [C]lose workspace' })
vim.keymap.set('n', '<leader>to', '<cmd>tabonly<cr>', { desc = '[T]ab [O]nly (close other workspaces)' })
vim.keymap.set('n', '<leader>tm', '<cmd>tabmove<cr>', { desc = '[T]ab [M]ove workspace' })

-- Buffer navigation within current tab/workspace (Tab-scoped)
-- These work only with buffers opened within the current tab
vim.keymap.set('n', '<Tab>', function()
  if _G.TabScopedBuffers then
    _G.TabScopedBuffers.next_buffer()
  end
end, { desc = 'Next buffer (in current tab)' })

vim.keymap.set('n', '<S-Tab>', function()
  if _G.TabScopedBuffers then
    _G.TabScopedBuffers.prev_buffer()
  end
end, { desc = 'Previous buffer (in current tab)' })

-- Buffer operations within current tab
-- Switch to buffer by number within current tab (1-9)
for i = 1, 9 do
  vim.keymap.set('n', '<leader>' .. i, function()
    if _G.TabScopedBuffers then
      _G.TabScopedBuffers.goto_buffer(i)
    end
  end, { desc = 'Buffer ' .. i .. ' (in current tab)' })
end

-- Additional buffer management keymaps
vim.keymap.set('n', '<leader>bc', function()
  if _G.TabScopedBuffers then
    _G.TabScopedBuffers.close_buffer()
  end
end, { desc = '[B]uffer [C]lose (tab-scoped)' })

vim.keymap.set('n', '<leader>bn', function()
  if _G.TabScopedBuffers then
    _G.TabScopedBuffers.next_buffer()
  end
end, { desc = '[B]uffer [N]ext (in current tab)' })

vim.keymap.set('n', '<leader>bp', function()
  if _G.TabScopedBuffers then
    _G.TabScopedBuffers.prev_buffer()
  end
end, { desc = '[B]uffer [P]revious (in current tab)' })


