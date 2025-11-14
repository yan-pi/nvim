-- lua/plugins/aerial.lua
-- Code outline and symbol navigation sidebar

return {
  'stevearc/aerial.nvim',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
  cmd = { 'AerialToggle', 'AerialOpen', 'AerialNavToggle' },
  opts = {
    -- Priority list of preferred backends for aerial
    backends = { 'treesitter', 'lsp', 'markdown', 'asciidoc', 'man' },

    layout = {
      -- These control the width of the aerial window
      max_width = { 40, 0.2 },
      width = nil,
      min_width = 20,

      -- Determines the default direction to open the aerial window
      default_direction = 'prefer_right',

      -- Determines where the aerial window will be opened
      placement = 'window',
    },

    -- Determines how the aerial window decides which buffer to display symbols for
    attach_mode = 'window',

    -- List of enum values that configure when to auto-close the aerial window
    close_automatic_events = {},

    -- Keymaps in aerial window
    keymaps = {
      ['?'] = 'actions.show_help',
      ['g?'] = 'actions.show_help',
      ['<CR>'] = 'actions.jump',
      ['<2-LeftMouse>'] = 'actions.jump',
      ['<C-v>'] = 'actions.jump_vsplit',
      ['<C-s>'] = 'actions.jump_split',
      ['p'] = 'actions.scroll',
      ['<C-j>'] = 'actions.down_and_scroll',
      ['<C-k>'] = 'actions.up_and_scroll',
      ['{'] = 'actions.prev',
      ['}'] = 'actions.next',
      ['[['] = 'actions.prev_up',
      [']]'] = 'actions.next_up',
      ['q'] = 'actions.close',
      ['o'] = 'actions.tree_toggle',
      ['za'] = 'actions.tree_toggle',
      ['O'] = 'actions.tree_toggle_recursive',
      ['zA'] = 'actions.tree_toggle_recursive',
      ['l'] = 'actions.tree_open',
      ['zo'] = 'actions.tree_open',
      ['L'] = 'actions.tree_open_recursive',
      ['zO'] = 'actions.tree_open_recursive',
      ['h'] = 'actions.tree_close',
      ['zc'] = 'actions.tree_close',
      ['H'] = 'actions.tree_close_recursive',
      ['zC'] = 'actions.tree_close_recursive',
      ['zr'] = 'actions.tree_increase_fold_level',
      ['zR'] = 'actions.tree_open_all',
      ['zm'] = 'actions.tree_decrease_fold_level',
      ['zM'] = 'actions.tree_close_all',
      ['zx'] = 'actions.tree_sync_folds',
      ['zX'] = 'actions.tree_sync_folds',
    },

    -- When true, aerial will automatically close after jumping to a symbol
    close_on_select = false,

    -- Show box drawing characters for the tree hierarchy
    show_guides = true,

    -- Customize the characters used when show_guides = true
    guides = {
      mid_item = '├─',
      last_item = '└─',
      nested_top = '│ ',
      whitespace = '  ',
    },

    -- Options for opening aerial in a floating win
    float = {
      border = 'rounded',
      relative = 'cursor',
      max_height = 0.9,
      height = nil,
      min_height = { 8, 0.1 },

      override = function(conf, source_winid)
        -- This is the config that will be passed to nvim_open_win
        -- Change values here to customize the layout
        return conf
      end,
    },

    -- Options for the floating nav windows
    nav = {
      border = 'rounded',
      max_height = 0.9,
      min_height = { 10, 0.1 },
      max_width = 0.5,
      min_width = { 0.2, 20 },
      win_opts = {
        cursorline = true,
        winblend = 10,
      },
      -- Jump to symbol in source window when the cursor moves
      autojump = false,
      -- Show a preview of the code in the right column, when there are no child symbols
      preview = false,
      keymaps = {
        ['<CR>'] = 'actions.jump',
        ['<2-LeftMouse>'] = 'actions.jump',
        ['<C-v>'] = 'actions.jump_vsplit',
        ['<C-s>'] = 'actions.jump_split',
        ['h'] = 'actions.left',
        ['l'] = 'actions.right',
        ['<C-c>'] = 'actions.close',
      },
    },

    lsp = {
      -- If true, fetch document symbols when LSP diagnostics update
      diagnostics_trigger_update = true,

      -- Set to false to not update the symbols when there are LSP errors
      update_when_errors = true,

      -- How long to wait (in ms) after a buffer change before updating
      update_delay = 300,

      -- Map of LSP client name to priority. Default value is 10
      -- Clients with higher priority will have their symbols used when multiple clients are attached
      priority = {
        pyright = 10,
      },
    },

    treesitter = {
      -- How long to wait (in ms) after a buffer change before updating
      update_delay = 300,
    },

    markdown = {
      -- How long to wait (in ms) after a buffer change before updating
      update_delay = 300,
    },
  },
  keys = {
    {
      '<leader>a',
      '<cmd>AerialToggle<cr>',
      desc = 'Toggle Aerial (Code Outline)',
    },
    {
      '<leader>A',
      '<cmd>AerialNavToggle<cr>',
      desc = 'Toggle Aerial Nav (Floating)',
    },
    {
      '[a',
      '<cmd>AerialPrev<cr>',
      desc = 'Previous Aerial Symbol',
    },
    {
      ']a',
      '<cmd>AerialNext<cr>',
      desc = 'Next Aerial Symbol',
    },
  },
}
