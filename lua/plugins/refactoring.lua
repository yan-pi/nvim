-- Advanced refactoring operations for multiple languages

return {
  'ThePrimeagen/refactoring.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  cmd = 'Refactor',
  opts = {
    prompt_func_return_type = {
      go = false,
      java = false,
      cpp = false,
      c = false,
      h = false,
      hpp = false,
      cxx = false,
    },
    prompt_func_param_type = {
      go = false,
      java = false,
      cpp = false,
      c = false,
      h = false,
      hpp = false,
      cxx = false,
    },
    printf_statements = {},
    print_var_statements = {},
    show_success_message = true,
  },
  keys = {
    -- Refactoring actions use uppercase R, leaving lowercase r for Rust.
    {
      '<leader>Re',
      function()
        require('refactoring').refactor 'Extract Function'
      end,
      mode = 'x',
      desc = 'Extract Function',
    },
    {
      '<leader>Rf',
      function()
        require('refactoring').refactor 'Extract Function To File'
      end,
      mode = 'x',
      desc = 'Extract Function To File',
    },
    {
      '<leader>Rv',
      function()
        require('refactoring').refactor 'Extract Variable'
      end,
      mode = 'x',
      desc = 'Extract Variable',
    },
    {
      '<leader>Ri',
      function()
        require('refactoring').refactor 'Inline Variable'
      end,
      mode = { 'n', 'x' },
      desc = 'Inline Variable',
    },
    {
      '<leader>Rb',
      function()
        require('refactoring').refactor 'Extract Block'
      end,
      desc = 'Extract Block',
    },
    {
      '<leader>RB',
      function()
        require('refactoring').refactor 'Extract Block To File'
      end,
      desc = 'Extract Block To File',
    },
    {
      '<leader>RI',
      function()
        require('refactoring').refactor 'Inline Function'
      end,
      desc = 'Inline Function',
    },
    -- Debug print actions share a dedicated sub-prefix.
    {
      '<leader>Rdp',
      function()
        require('refactoring').debug.printf { below = false }
      end,
      desc = 'Debug Print',
    },
    {
      '<leader>Rdv',
      function()
        require('refactoring').debug.print_var { normal = true }
      end,
      mode = { 'n', 'x' },
      desc = 'Debug Print Variable',
    },
    {
      '<leader>Rdc',
      function()
        require('refactoring').debug.cleanup {}
      end,
      desc = 'Debug Cleanup',
    },
    {
      '<leader>Rr',
      function()
        require('refactoring').select_refactor {
          show_success_message = true,
        }
      end,
      mode = { 'x', 'n' },
      desc = 'Refactor Menu',
    },
  },
}
