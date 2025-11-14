-- lua/plugins/venv-selector.lua
-- Python virtual environment selector

return {
  'linux-cultist/venv-selector.nvim',
  dependencies = {
    'neovim/nvim-lspconfig',
    'nvim-telescope/telescope.nvim',
    'mfussenegger/nvim-dap-python',
  },
  branch = 'regexp',
  ft = 'python',
  opts = {
    -- Auto select single venv if found
    auto_refresh = true,
    search_venv_managers = true,
    search_workspace = true,
    
    -- Search options
    search = true,
    dap_enabled = true,
    
    -- Paths to search for virtual environments
    path = {
      '~/.virtualenvs',
      '~/.pyenv/versions',
      './venv',
      './.venv',
      './env',
      './.env',
    },
    
    -- Name patterns for virtual environments
    name = {
      'venv',
      '.venv',
      'env',
      '.env',
      'virtualenv',
    },
    
    -- Parent directory patterns for workspace venvs
    parents = 0,
    
    -- Additional poetry/pipenv support
    poetry_path = vim.fn.expand('~/.poetry/'),
    pipenv_path = vim.fn.expand('~/.local/share/virtualenvs/'),
    pyenv_path = vim.fn.expand('~/.pyenv/versions/'),
  },
  keys = {
    {
      '<leader>vs',
      '<cmd>VenvSelect<cr>',
      desc = 'Select Python Virtual Environment',
      ft = 'python',
    },
    {
      '<leader>vc',
      '<cmd>VenvSelectCached<cr>',
      desc = 'Select Cached Python Venv',
      ft = 'python',
    },
    {
      '<leader>vd',
      function()
        require('venv-selector').deactivate()
      end,
      desc = 'Deactivate Python Venv',
      ft = 'python',
    },
    {
      '<leader>vi',
      function()
        local venv = require('venv-selector').get_active_venv()
        if venv then
          print('Active venv: ' .. venv)
        else
          print('No active virtual environment')
        end
      end,
      desc = 'Show Active Python Venv',
      ft = 'python',
    },
  },
}
