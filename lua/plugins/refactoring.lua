-- lua/plugins/refactoring.lua
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
    -- Extract function (visual mode)
    {
      '<leader>re',
      function()
        require('refactoring').refactor('Extract Function')
      end,
      mode = 'x',
      desc = 'Extract Function',
    },
    {
      '<leader>rf',
      function()
        require('refactoring').refactor('Extract Function To File')
      end,
      mode = 'x',
      desc = 'Extract Function To File',
    },
    -- Extract variable (visual mode)
    {
      '<leader>rv',
      function()
        require('refactoring').refactor('Extract Variable')
      end,
      mode = 'x',
      desc = 'Extract Variable',
    },
    -- Inline variable (normal and visual mode)
    {
      '<leader>ri',
      function()
        require('refactoring').refactor('Inline Variable')
      end,
      mode = { 'n', 'x' },
      desc = 'Inline Variable',
    },
    -- Extract block (normal mode)
    {
      '<leader>rb',
      function()
        require('refactoring').refactor('Extract Block')
      end,
      desc = 'Extract Block',
    },
    {
      '<leader>rB',
      function()
        require('refactoring').refactor('Extract Block To File')
      end,
      desc = 'Extract Block To File',
    },
    -- Inline function (normal mode)
    {
      '<leader>rI',
      function()
        require('refactoring').refactor('Inline Function')
      end,
      desc = 'Inline Function',
    },
    -- Debug operations
    {
      '<leader>rp',
      function()
        require('refactoring').debug.printf { below = false }
      end,
      desc = 'Debug Print',
    },
    {
      '<leader>rv',
      function()
        require('refactoring').debug.print_var { normal = true }
      end,
      desc = 'Debug Print Variable',
    },
    {
      '<leader>rv',
      function()
        require('refactoring').debug.print_var {}
      end,
      mode = 'x',
      desc = 'Debug Print Variable',
    },
    {
      '<leader>rc',
      function()
        require('refactoring').debug.cleanup {}
      end,
      desc = 'Debug Cleanup',
    },
    -- Refactor menu (with telescope if available)
    {
      '<leader>rr',
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
