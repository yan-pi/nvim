-- [[ Setting options ]]
-- See `:help vim.o`

-- Set leader keys
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- Make line numbers default
vim.o.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
vim.o.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.o.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.o.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Hide end-of-buffer tilde characters (~) by replacing them with spaces
-- See `:help 'fillchars'`
vim.opt.fillchars:append({ eob = ' ' })

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'

-- Show which line your cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.o.confirm = true

-- === TAB/INDENTATION SETTINGS ===
-- Use spaces instead of tabs
vim.o.expandtab = true
-- Number of spaces for each indentation level
vim.o.shiftwidth = 2
-- Number of spaces for a tab
vim.o.tabstop = 2
-- Number of spaces for tab when editing
vim.o.softtabstop = 2
-- Enable smart indenting
vim.o.smartindent = true
-- Copy indent from current line when starting new line
vim.o.autoindent = true

-- === COLORSCHEME PERSISTENCE ===
-- Enhanced theme persistence with validation and better error handling
local colorscheme_file = vim.fn.stdpath('data') .. '/colorscheme.json'

-- Available colorschemes for validation
local available_colorschemes = {
  'gruvbox',
  'tokyonight-night',
  'tokyonight-storm',
  'tokyonight-moon',
  'tokyonight-day',
  'kanagawa-wave',
  'kanagawa-dragon',
  'kanagawa-lotus',
  'catppuccin-latte',
  'catppuccin-frappe',
  'catppuccin-macchiato',
  'catppuccin-mocha',
  'oxocarbon',
  'habamax', -- Default fallback
}

-- Function to validate if colorscheme exists
local function is_colorscheme_available(name)
  if not name or name == '' then return false end

  -- Check if it's in our known list
  for _, scheme in ipairs(available_colorschemes) do
    if scheme == name then return true end
  end

  -- Try to load it to see if it exists
  local success = pcall(vim.cmd.colorscheme, name)
  return success
end

-- Function to save current colorscheme with metadata
local function save_colorscheme()
  local colorscheme = vim.g.colors_name
  if colorscheme and colorscheme ~= '' then
    local theme_data = {
      colorscheme = colorscheme,
      timestamp = os.time(),
      background = vim.o.background,
    }

    local success, encoded = pcall(vim.json.encode, theme_data)
    if success then
      local file = io.open(colorscheme_file, 'w')
      if file then
        file:write(encoded)
        file:close()
        -- Optional: Show notification
        -- vim.notify('Theme saved: ' .. colorscheme, vim.log.levels.INFO)
      else
        vim.notify('Failed to save theme: Cannot write file', vim.log.levels.WARN)
      end
    end
  end
end

-- Function to load saved colorscheme with fallback chain
local function load_colorscheme()
  local file = io.open(colorscheme_file, 'r')
  if file then
    local content = file:read('*all')
    file:close()

    if content and content ~= '' then
      local success, theme_data = pcall(vim.json.decode, content)
      if success and theme_data and theme_data.colorscheme then
        local saved_colorscheme = theme_data.colorscheme

        -- Validate and set colorscheme with fallback chain
        if is_colorscheme_available(saved_colorscheme) then
          local set_success = pcall(vim.cmd.colorscheme, saved_colorscheme)
          if set_success then
            -- Restore background setting if available
            if theme_data.background then
              vim.o.background = theme_data.background
            end
            return -- Successfully loaded
          end
        end
      end
    end
  end

  -- Fallback chain: gruvbox -> habamax -> default
  local fallbacks = { 'gruvbox', 'habamax', 'default' }
  for _, fallback in ipairs(fallbacks) do
    local success = pcall(vim.cmd.colorscheme, fallback)
    if success then
      vim.notify('Loaded fallback colorscheme: ' .. fallback, vim.log.levels.INFO)
      break
    end
  end
end

-- Save colorscheme when it changes (with debouncing)
local save_timer = nil
vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = '*',
  callback = function()
    -- Debounce to avoid multiple rapid saves
    if save_timer then
      vim.fn.timer_stop(save_timer)
    end
    save_timer = vim.fn.timer_start(500, function()
      save_colorscheme()
      save_timer = nil
    end)
  end,
  desc = 'Save colorscheme to file when changed',
})

-- Load saved colorscheme on startup (with delay to ensure themes are loaded)
vim.defer_fn(load_colorscheme, 150)