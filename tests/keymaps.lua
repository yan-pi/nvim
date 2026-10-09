local root = vim.fn.getcwd()
package.path = table.concat({ root .. '/lua/?.lua', root .. '/lua/?/init.lua', package.path }, ';')

local function read(path)
  local file = assert(io.open(root .. '/' .. path, 'r'))
  local content = file:read '*a'
  file:close()
  return content
end

local function contains(content, needle, message)
  assert(content:find(needle, 1, true), message or ('missing: ' .. needle))
end

local function excludes(content, needle, message)
  assert(not content:find(needle, 1, true), message or ('unexpected: ' .. needle))
end

local function get_plugin_keys(module_name, plugin_name)
  local specs = require(module_name)
  if specs[1] == plugin_name then
    return specs.keys or {}
  end
  for _, spec in ipairs(specs) do
    if spec[1] == plugin_name then
      return spec.keys or {}
    end
  end
  error('plugin spec not found: ' .. plugin_name)
end

local function has_key(keys, lhs, mode)
  for _, key in ipairs(keys) do
    local key_lhs = type(key) == 'string' and key or key[1]
    local modes = type(key) == 'table' and key.mode or nil
    if type(modes) == 'string' then
      modes = modes == '' and { 'n', 'x', 'o', 'i', 'c', 't' } or { modes }
    end
    if modes == nil then
      modes = { 'n' }
    end
    if key_lhs == lhs and vim.tbl_contains(modes, mode) then
      return true
    end
  end
  return false
end

local function count_key(keys, lhs, mode)
  local count = 0
  for _, key in ipairs(keys) do
    local key_lhs = type(key) == 'string' and key or key[1]
    local modes = type(key) == 'table' and key.mode or nil
    if type(modes) == 'string' then
      modes = modes == '' and { 'n', 'x', 'o', 'i', 'c', 't' } or { modes }
    end
    if modes == nil then
      modes = { 'n' }
    end
    if key_lhs == lhs and vim.tbl_contains(modes, mode) then
      count = count + 1
    end
  end
  return count
end

-- Blink owns completion's Ctrl+Space; core must not mask it with <Nop>.
local core_keymaps = read 'lua/core/keymaps.lua'
excludes(core_keymaps, "vim.keymap.set('i', '<C-Space>', '<Nop>'", 'core masks Blink Ctrl+Space')
local completion = require('plugins.completion')[1]
assert(completion.opts.keymap['<C-Space>'], 'Blink Ctrl+Space completion mapping is missing')
assert(completion.opts.keymap['<Tab>'] and completion.opts.keymap['<S-Tab>'], 'Blink navigation mappings changed')
contains(core_keymaps, "vim.keymap.set('n', '<leader>bN'", 'Buffer -> New mapping is missing')
excludes(core_keymaps, "vim.keymap.set('n', '<leader>b',", 'new buffer still captures the buffer prefix')
local terminal_escape = "vim.keymap.set('t', '<Esc><Esc>', '<C-" .. string.rep(string.char(92), 2) .. "><C-n>'"
contains(core_keymaps, terminal_escape, 'core terminal escape RHS is incorrect')
contains(read 'lua/plugins/terminal.lua', terminal_escape, 'ToggleTerm terminal escape RHS is incorrect')

local options = read 'lua/core/options.lua'
contains(options, 'vim.o.timeoutlen = 500', 'mapping timeout should allow normal typing speed')

local cpp_config = read 'lua/plugins/cpp.lua'
contains(cpp_config, "'<leader>ch'", 'C++ cppman help mapping is missing')
contains(cpp_config, "'cppman', '-p', 'less', '-f', query", 'C++ cppman mapping should launch an interactive terminal lookup')

local formatting_keys = get_plugin_keys('plugins.formatting', 'stevearc/conform.nvim')
assert(has_key(formatting_keys, '<leader>cf', 'n'), 'Code -> Format mapping is missing')
assert(not has_key(formatting_keys, '<leader>f', 'n'), 'formatting still owns the files prefix')

local snacks_keys = get_plugin_keys('plugins.snacks', 'folke/snacks.nvim')
assert(has_key(snacks_keys, '<leader>uz', 'n'), 'UI -> Zen mapping is missing')
assert(not has_key(snacks_keys, '<leader>z', 'n'), 'Zen still owns the vault prefix')
assert(has_key(snacks_keys, '<leader>gB', 'n'), 'Git Browse mapping is missing')
assert(has_key(snacks_keys, 'gI', 'n') and has_key(snacks_keys, '<leader>gI', 'n'), 'implementation and GitHub issue mappings must remain separate')
assert(count_key(snacks_keys, '<leader>sb', 'n') == 1, 'duplicate Snacks buffer-line mapping remains')

local git_keys = get_plugin_keys('plugins.git', 'f-person/git-blame.nvim')
assert(has_key(git_keys, '<leader>uB', 'n'), 'UI -> Git Blame mapping is missing')
assert(not has_key(git_keys, '<leader>gB', 'n'), 'Git Blame conflicts with Git Browse')

local testing_keys = get_plugin_keys('plugins.testing', 'nvim-neotest/neotest')
assert(has_key(testing_keys, '<leader>T[', 'n'), 'Neotest previous-failure mapping is missing')
assert(has_key(testing_keys, '<leader>T]', 'n'), 'Neotest next-failure mapping is missing')
assert(not has_key(testing_keys, '[t', 'n') and not has_key(testing_keys, ']t', 'n'), 'Neotest shadows Treesitter navigation')

local neogen_keys = get_plugin_keys('plugins.neogen', 'danymat/neogen')
assert(has_key(neogen_keys, '<leader>cDd', 'n'), 'Code -> Documentation default mapping is missing')
assert(has_key(neogen_keys, '<leader>cDf', 'n') and has_key(neogen_keys, '<leader>cDc', 'n'), 'specialized documentation mappings changed')
assert(has_key(neogen_keys, '<leader>cDt', 'n') and has_key(neogen_keys, '<leader>cDF', 'n'), 'specialized documentation mappings changed')
assert(not has_key(neogen_keys, '<leader>cD', 'n'), 'documentation prefix is still an action')

local refactor_keys = get_plugin_keys('plugins.refactoring', 'ThePrimeagen/refactoring.nvim')
local expected_refactor_modes = {
  ['<leader>Re'] = { 'x' },
  ['<leader>Rf'] = { 'x' },
  ['<leader>Rv'] = { 'x' },
  ['<leader>Ri'] = { 'n', 'x' },
  ['<leader>Rb'] = { 'n' },
  ['<leader>RB'] = { 'n' },
  ['<leader>RI'] = { 'n' },
  ['<leader>Rdp'] = { 'n' },
  ['<leader>Rdv'] = { 'n', 'x' },
  ['<leader>Rdc'] = { 'n' },
  ['<leader>Rr'] = { 'n', 'x' },
}
for lhs, modes in pairs(expected_refactor_modes) do
  for _, mode in ipairs(modes) do
    assert(has_key(refactor_keys, lhs, mode), ('refactoring mapping missing: %s in %s mode'):format(lhs, mode))
    assert(count_key(refactor_keys, lhs, mode) == 1, ('duplicate refactoring mapping: %s in %s mode'):format(lhs, mode))
  end
end

local mini = read 'lua/plugins/mini.lua'
contains(mini, "treesitter = { suffix = 't' }", 'MiniBracketed Treesitter navigation [t/]t is not explicitly enabled')
for _, mapping in ipairs {
  "add = '<leader>csa'",
  "delete = '<leader>csd'",
  "replace = '<leader>csr'",
  "find = '<leader>csf'",
  "find_left = '<leader>csF'",
  "highlight = '<leader>csh'",
  "suffix_next = 'n'",
} do
  contains(mini, mapping, 'MiniSurround mapping missing: ' .. mapping)
end

local key_specs = {
  formatting_keys,
  snacks_keys,
  git_keys,
  testing_keys,
  neogen_keys,
  refactor_keys,
}
local declared = {}
for _, keys in ipairs(key_specs) do
  for _, key in ipairs(keys) do
    local lhs = type(key) == 'string' and key or key[1]
    local modes = type(key) == 'table' and key.mode or nil
    if type(modes) == 'string' then
      modes = modes == '' and { 'n', 'x', 'o', 'i', 'c', 't' } or { modes }
    end
    modes = modes or { 'n' }
    for _, mode in ipairs(modes) do
      local id = mode .. ':' .. lhs
      assert(not declared[id], 'conflicting configured mapping: ' .. id)
      declared[id] = true
    end
  end
end

local git_docs = read 'SNACKS_KEYBINDS.md'
contains(git_docs, '| `<leader>gB` | Git browse', 'Snacks keybinding reference does not document Git Browse')
contains(git_docs, '| `<leader>uB` | Toggle Git blame', 'Snacks keybinding reference does not document Git Blame')

print 'keymap regression tests passed'
