-- UI and appearance plugins

return {
  -- Useful plugin to show you pending keybinds.
  {
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    opts = {
      -- delay between pressing a key and opening which-key (milliseconds)
      -- this setting is independent of vim.o.timeoutlen
      delay = 0,
      icons = {
        -- set icon mappings to true if you have a Nerd Font
        mappings = vim.g.have_nerd_font,
        -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
        -- default which-key.nvim defined Nerd Font icons, otherwise define a string table
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },

      -- Document existing key chains
      spec = {
        { '<leader>f', group = '[F]ind & Files' },
        { '<leader>s', group = '[S]earch & Symbols' },
        { '<leader>g', group = '[G]it Operations' },
        { '<leader>t', group = '[T]ab Management' },
        { '<leader>b', group = '[B]uffer Operations' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
        { '<leader>e', desc = 'File [E]xplorer (current file)' },
        { '<leader>E', desc = 'File [E]xplorer (cwd)' },
        { '<leader>u', group = '[U]I & Toggles' },
        { '<leader>1', desc = 'Buffer 1 (in current tab)' },
        { '<leader>2', desc = 'Buffer 2 (in current tab)' },
        { '<leader>3', desc = 'Buffer 3 (in current tab)' },
        { '<leader>4', desc = 'Buffer 4 (in current tab)' },
        { '<leader>5', desc = 'Buffer 5 (in current tab)' },
        { '<leader>6', desc = 'Buffer 6 (in current tab)' },
        { '<leader>7', desc = 'Buffer 7 (in current tab)' },
        { '<leader>8', desc = 'Buffer 8 (in current tab)' },
        { '<leader>9', desc = 'Buffer 9 (in current tab)' },
      },
    },
  },

  {
    'sainnhe/gruvbox-material',
    lazy = false,
    priority = 1000,
    config = function()
      -- Optionally configure and load the colorscheme
      -- directly inside the plugin declaration.
      vim.g.gruvbox_material_enable_italic = true
      vim.cmd.colorscheme 'gruvbox-material'
    end,
  },
  { 'EdenEast/nightfox.nvim' }, -- lazy

  -- {
  --   'morhetz/gruvbox',
  --   priority = 1000,
  --   config = function()
  --     -- Gruvbox configuration
  --     vim.g.gruvbox_contrast_dark = 'medium' -- soft, medium, hard
  --     vim.g.gruvbox_contrast_light = 'medium'
  --     vim.g.gruvbox_italic = 1 -- Disable italics
  --     vim.g.gruvbox_bold = 1 -- Enable bold
  --
  --     -- Load the colorscheme
  --     vim.cmd.colorscheme 'gruvbox'
  --   end,
  -- },
  --
  -- Alternative colorschemes (uncomment to use)
  {
    'folke/tokyonight.nvim',
    priority = 1000,
    opts = {
      style = 'night', -- storm, moon, night, day
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
      },
      on_colors = function(colors)
        -- Customize colors if needed
      end,
    },
    -- Uncomment to activate:
    -- config = function()
    --   require('tokyonight').setup(require('tokyonight').opts or {})
    --   vim.cmd.colorscheme 'tokyonight-night'
    -- end,
  },

  {
    'rebelot/kanagawa.nvim',
    priority = 1000,
    opts = {
      compile = false,
      undercurl = true,
      commentStyle = { italic = true },
      functionStyle = {},
      keywordStyle = { italic = true },
      statementStyle = { bold = true },
      typeStyle = {},
      transparent = false,
      dimInactive = false,
      terminalColors = true,
      colors = {
        palette = {},
        theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
      },
    },
    -- Uncomment to activate:
    -- config = function(_, opts)
    --   require('kanagawa').setup(opts)
    --   vim.cmd.colorscheme 'kanagawa-wave'
    -- end,
  },

  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    opts = {
      flavour = 'mocha', -- latte, frappe, macchiato, mocha
      background = {
        light = 'latte',
        dark = 'mocha',
      },
      transparent_background = false,
      show_end_of_buffer = false,
      term_colors = false,
      dim_inactive = {
        enabled = false,
        shade = 'dark',
        percentage = 0.15,
      },
      no_italic = false, -- Force no italic
      no_bold = false, -- Force no bold
      styles = {
        comments = {},
        conditionals = {},
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
      },
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        telescope = true,
        mini = true,
      },
    },
    -- Uncomment to activate:
    -- config = function(_, opts)
    --   require('catppuccin').setup(opts)
    --   vim.cmd.colorscheme 'catppuccin'
    -- end,
  },

  {
    'nyoom-engineering/oxocarbon.nvim',
    priority = 1000,
    -- Uncomment to activate:
    -- config = function()
    --   vim.cmd.colorscheme 'oxocarbon'
    -- end,
  },
}
