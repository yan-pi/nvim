-- Terminal management with toggleterm.nvim

return {
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    keys = {
      { '<leader>th', desc = '[T]erminal [H]orizontal toggle' },
      { '<leader>tv', desc = '[T]erminal [V]ertical toggle' },
      { '<leader>ti', desc = '[T]erminal Float toggle' },
      { '<leader>ta', desc = '[T]erminal toggle [A]ll' },
      { '<leader>ts', desc = '[T]erminal [S]elect' },
    },
    cmd = {
      'ToggleTerm',
      'ToggleTermToggleAll',
      'TermSelect',
      'ToggleTermSendCurrentLine',
      'ToggleTermSendVisualLines',
      'ToggleTermSendVisualSelection',
    },
    config = function()
      require('toggleterm').setup {
        -- Basic configuration
        open_mapping = false, -- Disable default mapping, use custom ones
        hide_numbers = true,
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = false, -- Disable to avoid conflicts
        terminal_mappings = false, -- Use custom mappings instead
        persist_size = true,
        persist_mode = true,
        direction = 'float', -- Default direction
        close_on_exit = true,
        shell = vim.o.shell,
        auto_scroll = true,
        -- Float terminal specific options
        float_opts = {
          border = 'curved',
          width = function()
            return math.floor(vim.o.columns * 0.8)
          end,
          height = function()
            return math.floor(vim.o.lines * 0.8)
          end,
          winblend = 0,
          zindex = 1000,
        },
        -- Size for horizontal and vertical terminals
        size = function(term)
          if term.direction == 'horizontal' then
            return 20
          elseif term.direction == 'vertical' then
            return math.floor(vim.o.columns * 0.4)
          end
        end,
        -- Exclude from bufferlist
        exclude_from_bufferlist = true,
      }

      -- Import Terminal class
      local Terminal = require('toggleterm.terminal').Terminal

      -- Create horizontal terminal (bottom split)
      local horizontal_term = Terminal:new {
        direction = 'horizontal',
        count = 1,
        display_name = 'Horizontal Terminal',
        hidden = false,
        start_in_insert = true,
        close_on_exit = true,
        auto_scroll = true,
      }

      -- Create vertical terminal (right split)
      local vertical_term = Terminal:new {
        direction = 'vertical',
        count = 2,
        display_name = 'Vertical Terminal',
        hidden = false,
        start_in_insert = true,
        close_on_exit = true,
        auto_scroll = true,
      }

      -- Create floating terminal (center overlay)
      local float_term = Terminal:new {
        direction = 'float',
        count = 3,
        display_name = 'Float Terminal',
        hidden = false,
        start_in_insert = true,
        close_on_exit = true,
        auto_scroll = true,
        float_opts = {
          border = 'curved',
          width = function()
            return math.floor(vim.o.columns * 0.85)
          end,
          height = function()
            return math.floor(vim.o.lines * 0.85)
          end,
          winblend = 0,
          zindex = 1000,
        },
      }

      -- Smart toggle function inspired by NvChad
      local function smart_toggle(terminal)
        local buf = terminal.bufnr
        if buf and vim.api.nvim_buf_is_valid(buf) then
          local win_id = vim.fn.bufwinid(buf)
          if win_id ~= -1 then
            -- Terminal is visible, close it
            vim.api.nvim_win_close(win_id, true)
          else
            -- Terminal exists but not visible, show it
            terminal:open()
          end
        else
          -- Terminal doesn't exist, create and show it
          terminal:open()
        end
      end

      -- Create toggle functions with smart logic
      function _horizontal_toggle()
        smart_toggle(horizontal_term)
      end

      function _vertical_toggle()
        smart_toggle(vertical_term)
      end

      function _float_toggle()
        smart_toggle(float_term)
      end

      -- Set up leader key combinations for quick terminal access
      -- Normal mode
      vim.keymap.set('n', '<leader>th', function()
        _horizontal_toggle()
      end, { desc = '[T]erminal [H]orizontal toggle', noremap = true, silent = true })

      vim.keymap.set('n', '<leader>tv', function()
        _vertical_toggle()
      end, { desc = '[T]erminal [V]ertical toggle', noremap = true, silent = true })

      vim.keymap.set('n', '<leader>ti', function()
        _float_toggle()
      end, { desc = '[T]erminal [I] Float toggle', noremap = true, silent = true })

      -- Terminal mode keybindings for easy escape and toggle
      vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit to normal mode' })
      vim.keymap.set('t', '<C-q>', '<C-\\><C-n>:close<CR>', { desc = 'Close terminal from terminal mode' })

      -- Leader combinations work from terminal mode too
      -- vim.keymap.set('t', '<leader>th', function()
      --   vim.cmd('stopinsert')
      --   _horizontal_toggle()
      -- end, { desc = '[T]erminal [H]orizontal from terminal' })
      -- vim.keymap.set('t', '<leader>tv', function()
      --   vim.cmd('stopinsert')
      --   _vertical_toggle()
      -- end, { desc = '[T]erminal [V]ertical from terminal' })
      -- vim.keymap.set('t', '<leader>ti', function()
      --   vim.cmd('stopinsert')
      --   _float_toggle()
      -- end, { desc = '[T]erminal [I] Float from terminal' })

      -- Terminal mode keymaps for easier navigation
      vim.keymap.set('t', '<C-h>', function()
        vim.cmd.wincmd 'h'
      end, { desc = 'Move to left window from terminal' })

      vim.keymap.set('t', '<C-j>', function()
        vim.cmd.wincmd 'j'
      end, { desc = 'Move to bottom window from terminal' })

      vim.keymap.set('t', '<C-k>', function()
        vim.cmd.wincmd 'k'
      end, { desc = 'Move to top window from terminal' })

      vim.keymap.set('t', '<C-l>', function()
        vim.cmd.wincmd 'l'
      end, { desc = 'Move to right window from terminal' })

      -- Additional utility keymaps
      vim.keymap.set('n', '<leader>ta', ':ToggleTermToggleAll<CR>', { desc = 'Toggle all terminals', noremap = true, silent = true })
      vim.keymap.set('n', '<leader>ts', ':TermSelect<CR>', { desc = 'Select terminal', noremap = true, silent = true })
    end,
  },
}

