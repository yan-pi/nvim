-- Minimal configuration for reading and navigating text and Bash files.
local config_path = vim.fn.fnamemodify(debug.getinfo(1, 'S').source:sub(2), ':p:h')
vim.opt.rtp:prepend(config_path)

require 'core.options'
require 'core.keymaps'
require 'core.autocmds'

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

vim.opt.rtp:prepend(lazypath)

local plugin_specs = {}
for _, plugin in ipairs { 'mini', 'snacks', 'ui', 'bufferline', 'terminal' } do
  vim.list_extend(plugin_specs, require('plugins.' .. plugin))
end

require('lazy').setup(plugin_specs, {
  change_detection = { notify = false },
  checker = { enabled = false },
  ui = {
    icons = {
      cmd = ':',
      config = 'C',
      event = 'E',
      ft = 'F',
      init = 'I',
      keys = 'K',
      plugin = 'P',
      runtime = 'R',
      require = 'r',
      source = 'S',
      start = '>',
      task = 'T',
      lazy = 'L',
    },
  },
})

-- vim: ts=2 sts=2 sw=2 et
