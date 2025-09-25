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
        { '<leader>s', group = '[S]earch' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
        { '<leader>p', group = '[P]ick' },
        { '<leader>e', desc = 'File [E]xplorer (current file)' },
        { '<leader>E', desc = 'File [E]xplorer (cwd)' },
        { '<leader>th', desc = '[T]heme [H]elper' },
      },
    },
  },

  -- === COLORSCHEMES ===
  -- You can easily switch between colorschemes using <leader>th (Themery)
  -- or :Themery command. Changes persist across Neovim sessions.

  -- Gruvbox (Currently Active)
  {
    'morhetz/gruvbox',
    priority = 1000,
    config = function()
      -- Gruvbox configuration
      vim.g.gruvbox_contrast_dark = 'medium' -- soft, medium, hard
      vim.g.gruvbox_contrast_light = 'medium'
      vim.g.gruvbox_italic = 0 -- Disable italics
      vim.g.gruvbox_bold = 1 -- Enable bold

      -- Load the colorscheme
      vim.cmd.colorscheme 'gruvbox'
    end,
  },

  -- Alternative colorschemes (uncomment to use)
  {
    'folke/tokyonight.nvim',
    priority = 1000,
    opts = {
      style = 'night', -- storm, moon, night, day
      styles = {
        comments = { italic = false },
        keywords = { italic = false },
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
      commentStyle = { italic = false },
      functionStyle = {},
      keywordStyle = { italic = false },
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
      no_italic = true, -- Force no italic
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
