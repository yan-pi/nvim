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
  -- You can easily switch between colorschemes using :Telescope colorscheme
  -- or by changing the active theme in the config section below

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

  -- === THEME PERSISTENCE (Custom Implementation) ===
  {
    'nvim-lua/plenary.nvim', -- Dependency for file operations
    config = function()
      local data_path = vim.fn.stdpath('data')
      local colorscheme_file = data_path .. '/last_colorscheme.txt'

      -- Function to save current colorscheme
      local function save_colorscheme()
        local current_colorscheme = vim.g.colors_name
        if current_colorscheme then
          local file = io.open(colorscheme_file, 'w')
          if file then
            file:write(current_colorscheme)
            file:close()
          end
        end
      end

      -- Function to load saved colorscheme
      local function load_colorscheme()
        local file = io.open(colorscheme_file, 'r')
        if file then
          local saved_colorscheme = file:read('*all'):gsub('%s+', '') -- Remove whitespace
          file:close()

          if saved_colorscheme and saved_colorscheme ~= '' then
            -- Try to set the saved colorscheme
            local success = pcall(vim.cmd.colorscheme, saved_colorscheme)
            if not success then
              -- Fallback to gruvbox if saved theme doesn't exist
              pcall(vim.cmd.colorscheme, 'gruvbox')
            end
          end
        end
      end

      -- Load saved colorscheme on startup (with delay to ensure themes are loaded)
      vim.defer_fn(load_colorscheme, 100)

      -- Save colorscheme when it changes
      vim.api.nvim_create_autocmd('ColorScheme', {
        pattern = '*',
        callback = function()
          vim.defer_fn(save_colorscheme, 50)
        end,
        desc = 'Save colorscheme to file when changed',
      })
    end,
  },

  -- === KEYMAPS ===
  {
    'nvim-telescope/telescope.nvim',
    optional = true,
    config = function()
      -- Global keymap for theme selector (works in any buffer)
      vim.keymap.set('n', '<leader>th', function()
        -- Check if telescope is available
        local telescope_ok, telescope = pcall(require, 'telescope.builtin')
        if telescope_ok then
          telescope.colorscheme({ enable_preview = true })
        else
          vim.notify('Telescope not available', vim.log.levels.ERROR)
        end
      end, { desc = '[T]heme [H]elper', silent = true })
    end,
  },
}
