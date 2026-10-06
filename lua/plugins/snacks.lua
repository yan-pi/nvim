return {
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = {
      picker = { enabled = true },
    },
    keys = {
      {
        '<leader><space>',
        function()
          Snacks.picker.smart()
        end,
        desc = 'Find files',
      },
      {
        '<leader>,',
        function()
          Snacks.picker.buffers()
        end,
        desc = 'Buffers',
      },
      {
        '<leader>/',
        function()
          Snacks.picker.grep()
        end,
        desc = 'Grep',
      },
      {
        '<leader>ff',
        function()
          Snacks.picker.files()
        end,
        desc = 'Find files',
      },
      {
        '<leader>fg',
        function()
          Snacks.picker.git_files()
        end,
        desc = 'Find Git files',
      },
      {
        '<leader>fr',
        function()
          Snacks.picker.recent()
        end,
        desc = 'Recent files',
      },
      {
        '<leader>sb',
        function()
          Snacks.picker.lines()
        end,
        desc = 'Buffer lines',
      },
      {
        '<leader>sg',
        function()
          Snacks.picker.grep()
        end,
        desc = 'Grep files',
      },
      {
        '<leader>sw',
        function()
          Snacks.picker.grep_word()
        end,
        mode = { 'n', 'x' },
        desc = 'Search word',
      },
      {
        '<leader>sh',
        function()
          Snacks.picker.help()
        end,
        desc = 'Help tags',
      },
      {
        '<leader>sm',
        function()
          Snacks.picker.man()
        end,
        desc = 'Man pages',
      },
      {
        '<leader>s"',
        function()
          Snacks.picker.registers()
        end,
        desc = 'Registers',
      },
      {
        '<leader>s/',
        function()
          Snacks.picker.search_history()
        end,
        desc = 'Search history',
      },
      {
        '<leader>bd',
        function()
          TabScopedBuffers.close_buffer()
        end,
        desc = 'Close buffer',
      },
    },
  },
}
