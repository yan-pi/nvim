-- Terminal management with toggleterm.nvim

return {
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    event = 'VeryLazy',
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

      -- Set up Alt key combinations for quick terminal access (conflict-free)
      -- Normal mode
      vim.keymap.set('n', '<M-h>', function()
        _horizontal_toggle()
      end, { desc = 'Toggle horizontal terminal', noremap = true, silent = true })

      vim.keymap.set('n', '<M-v>', function()
        _vertical_toggle()
      end, { desc = 'Toggle vertical terminal', noremap = true, silent = true })

      vim.keymap.set('n', '<M-i>', function()
        _float_toggle()
      end, { desc = 'Toggle floating terminal', noremap = true, silent = true })

      -- Insert mode - seamless toggle without exiting insert mode
      vim.keymap.set('i', '<M-h>', '<C-o>:lua _horizontal_toggle()<CR>', { desc = 'Toggle horizontal from insert', noremap = true, silent = true })
      vim.keymap.set('i', '<M-v>', '<C-o>:lua _vertical_toggle()<CR>', { desc = 'Toggle vertical from insert', noremap = true, silent = true })
      vim.keymap.set('i', '<M-i>', '<C-o>:lua _float_toggle()<CR>', { desc = 'Toggle float from insert', noremap = true, silent = true })

      -- Visual and Select modes
      vim.keymap.set('v', '<M-h>', '<Esc>:lua _horizontal_toggle()<CR>', { desc = 'Toggle horizontal from visual', noremap = true, silent = true })
      vim.keymap.set('v', '<M-v>', '<Esc>:lua _vertical_toggle()<CR>', { desc = 'Toggle vertical from visual', noremap = true, silent = true })
      vim.keymap.set('v', '<M-i>', '<Esc>:lua _float_toggle()<CR>', { desc = 'Toggle float from visual', noremap = true, silent = true })

      -- Terminal mode keybindings for easy escape and toggle
      vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit to normal mode' })
      vim.keymap.set('t', '<C-q>', '<C-\\><C-n>:close<CR>', { desc = 'Close terminal from terminal mode' })

      -- Alt key combinations work from terminal mode too (improved reliability)
      vim.keymap.set('t', '<M-h>', function()
        vim.cmd('stopinsert')
        _horizontal_toggle()
      end, { desc = 'Toggle horizontal from terminal' })
      vim.keymap.set('t', '<M-v>', function()
        vim.cmd('stopinsert')
        _vertical_toggle()
      end, { desc = 'Toggle vertical from terminal' })
      vim.keymap.set('t', '<M-i>', function()
        vim.cmd('stopinsert')
        _float_toggle()
      end, { desc = 'Toggle floating from terminal' })

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