local test_path = debug.getinfo(1, 'S').source:sub(2)
local root = vim.fn.fnamemodify(test_path, ':p:h:h')

local function assert_true(value, message)
  assert(value, message)
end

local function assert_equal(expected, actual, message)
  assert(expected == actual, string.format('%s (expected %q, got %q)', message, expected, actual))
end

assert_equal(' ', vim.g.mapleader, 'leader key')
assert_equal('base16-gruvbox-material-dark-hard', vim.g.colors_name, 'colorscheme')
assert_true(vim.g.have_nerd_font == false, 'Nerd Font must not be required')
assert_true(vim.o.clipboard:find('unnamedplus', 1, true) ~= nil, 'unnamedplus clipboard option')
if vim.fn.executable 'pbcopy' == 1 and vim.fn.executable 'pbpaste' == 1 then
  assert_true(vim.g.clipboard ~= nil, 'OrbStack clipboard provider should be configured')
  assert_equal('OrbStack host clipboard', vim.g.clipboard.name, 'OrbStack clipboard provider name')
  assert_equal('pbcopy', vim.g.clipboard.copy['+'][1], 'OrbStack copy command')
  assert_equal('pbpaste', vim.g.clipboard.paste['+'][1], 'OrbStack paste command')
end
assert_true(vim.fn.maparg('<leader>e', 'n') ~= '', 'explorer mapping')
assert_true(vim.fn.maparg('<leader>ff', 'n') ~= '', 'file picker mapping')
for _, lhs in ipairs { '<leader>th', '<leader>tv', '<leader>ti', '<leader>ta', '<leader>ts' } do
  assert_true(vim.fn.maparg(lhs, 'n') ~= '', 'terminal mapping: ' .. lhs)
end
assert_true(vim.fn.maparg('<leader>ty', 'n') ~= '', 'new tab mapping must remain available')
assert_true(_G.MiniFiles ~= nil, 'Mini.files should be loaded')
assert_true(_G.TabScopedBuffers ~= nil, 'tab-scoped buffers should be loaded')

local plugins = require('lazy').plugins()
local allowed = {
  ['mini.nvim'] = true,
  ['snacks.nvim'] = true,
  ['which-key.nvim'] = true,
  ['base16-nvim'] = true,
  ['bufferline.nvim'] = true,
  ['toggleterm.nvim'] = true,
}
local plugin_names = {}
for _, plugin in pairs(plugins) do
  plugin_names[plugin.name] = true
end
plugin_names['lazy.nvim'] = true
for name in pairs(plugin_names) do
  assert_true(allowed[name] == true or name == 'lazy.nvim', 'unexpected plugin loaded: ' .. name)
end
for name in pairs(allowed) do
  assert_true(plugin_names[name] == true, 'expected plugin missing: ' .. name)
end

local toggleterm
for _, plugin in pairs(plugins) do
  if plugin.name == 'toggleterm.nvim' then
    toggleterm = plugin
    break
  end
end
assert_true(toggleterm ~= nil, 'ToggleTerm plugin spec should be registered')
assert_true(toggleterm.lazy == true, 'ToggleTerm should remain lazy-loaded')
vim.cmd 'Lazy load toggleterm.nvim'
assert_true(vim.fn.exists ':ToggleTerm' == 2, 'ToggleTerm command should load the terminal plugin')
for _, lhs in ipairs { '<Esc><Esc>', '<C-q>', '<C-h>', '<C-j>', '<C-k>', '<C-l>' } do
  assert_true(vim.fn.maparg(lhs, 't') ~= '', 'terminal-mode mapping: ' .. lhs)
end

MiniFiles.open(root .. '/tests/fixtures')
local explorer_buf
vim.wait(100, function()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[bufnr].filetype == 'minifiles' then
      explorer_buf = bufnr
      return true
    end
  end
  return false
end)
assert_true(explorer_buf ~= nil, 'Mini.files explorer should open')
local enter_mapping
vim.api.nvim_buf_call(explorer_buf, function()
  enter_mapping = vim.fn.maparg('<CR>', 'n', false, true)
end)
assert_true(enter_mapping ~= nil and enter_mapping.rhs == 'l', 'Mini.files Enter should open entries')
MiniFiles.close()

vim.cmd.edit(root .. '/tests/fixtures/readme.txt')
assert_equal('text', vim.bo.filetype, 'text fixture filetype')
vim.cmd.edit(root .. '/tests/fixtures/example.sh')
assert_equal('sh', vim.bo.filetype, 'Bash fixture filetype')

local tab_buffers = _G.TabScopedBuffers.get_tab_buffers()
assert_true(#tab_buffers >= 2, 'opened fixtures should be tracked in the tab')
local current = vim.api.nvim_get_current_buf()
_G.TabScopedBuffers.prev_buffer()
assert_true(vim.api.nvim_get_current_buf() ~= current, 'previous buffer navigation')
_G.TabScopedBuffers.next_buffer()
assert_equal(current, vim.api.nvim_get_current_buf(), 'next buffer navigation')

print 'kali-minimal tests passed'
