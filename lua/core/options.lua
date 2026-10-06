vim.g.mapleader = ' '
vim.g.maplocalleader = ','
vim.g.have_nerd_font = false

-- OrbStack exposes the macOS clipboard through pbcopy/pbpaste inside Linux
-- machines. Use it when available, while preserving Neovim's normal provider
-- detection everywhere else.
if vim.fn.executable 'pbcopy' == 1 and vim.fn.executable 'pbpaste' == 1 then
  vim.g.clipboard = {
    name = 'OrbStack host clipboard',
    copy = {
      ['+'] = { 'pbcopy' },
      ['*'] = { 'pbcopy' },
    },
    paste = {
      ['+'] = { 'pbpaste' },
      ['*'] = { 'pbpaste' },
    },
    cache_enabled = 0,
  }
end
vim.opt.clipboard:append 'unnamedplus'

vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = 'a'
vim.o.showmode = false
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = 'yes'
vim.o.updatetime = 300
vim.o.timeoutlen = 300
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.termguicolors = true
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.fillchars:append { eob = ' ' }
vim.o.inccommand = 'split'
vim.o.cursorline = true
vim.o.scrolloff = 8
vim.o.confirm = true

vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.smartindent = true
vim.o.autoindent = true
