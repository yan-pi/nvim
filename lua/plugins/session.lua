-- Session persistence for seamless project switching
-- Automatically saves and restores your editor state

return {
  {
    'folke/persistence.nvim',
    event = 'BufReadPre',
    opts = {
      dir = vim.fn.expand(vim.fn.stdpath 'state' .. '/sessions/'), -- Session directory
      options = { 'buffers', 'curdir', 'tabpages', 'winsize', 'help', 'globals', 'skiprtp' },
      pre_save = nil, -- Function to run before saving session
      post_save = nil, -- Function to run after saving session  
      save_empty = false, -- Don't save if no buffers
      pre_load = nil, -- Function to run before loading session
      post_load = nil, -- Function to run after loading session
    },
    keys = {
      {
        '<leader>Qs',
        function()
          require('persistence').load()
        end,
        desc = '[Q]uit/Session: Load session for current directory',
      },
      {
        '<leader>QS',
        function()
          require('persistence').select()
        end,
        desc = '[Q]uit/Session: [S]elect session to load',
      },
      {
        '<leader>Ql',
        function()
          require('persistence').load { last = true }
        end,
        desc = '[Q]uit/Session: Load [l]ast session',
      },
      {
        '<leader>Qd',
        function()
          require('persistence').stop()
        end,
        desc = "[Q]uit/Session: [D]on't save current session",
      },
    },
    init = function()
      -- Auto-restore last session when starting nvim without arguments
      local function restore_session()
        if vim.fn.argc(-1) == 0 then
          -- Only restore if no arguments were given
          require('persistence').load { last = true }
        end
      end

      -- Uncomment to enable auto-restore on startup
      -- vim.api.nvim_create_autocmd('VimEnter', {
      --   callback = function()
      --     restore_session()
      --   end,
      --   nested = true,
      -- })
    end,
  },
}
