-- Pinned-file navigation. Complements snacks.picker (discovery) with
-- harpoon (return). Workflow: pin test+impl+types per session, jump
-- between them in O(1).
--
-- Prefix: <leader>m* (mark). Avoids conflict with <leader>h* (Git Hunk)
-- and <leader>1..9 (TabScopedBuffers).

return {
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = function()
      local harpoon = require('harpoon')
      return {
        { '<leader>ma', function() harpoon:list():add() end, desc = 'Harpoon add' },
        { '<leader>mh', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, desc = 'Harpoon menu' },
        { '<leader>mj', function() harpoon:list():next() end, desc = 'Harpoon next' },
        { '<leader>mk', function() harpoon:list():prev() end, desc = 'Harpoon prev' },
        { '<leader>m1', function() harpoon:list():select(1) end, desc = 'Harpoon 1' },
        { '<leader>m2', function() harpoon:list():select(2) end, desc = 'Harpoon 2' },
        { '<leader>m3', function() harpoon:list():select(3) end, desc = 'Harpoon 3' },
        { '<leader>m4', function() harpoon:list():select(4) end, desc = 'Harpoon 4' },
      }
    end,
    config = function()
      require('harpoon'):setup()
    end,
  },
}
