-- Modal jump motion: 's' + 2 chars to teleport anywhere visible.
-- Treesitter integration for selecting whole nodes (functions, blocks).
--
-- Keymaps (n/x/o = normal, visual, operator-pending):
--   s   Jump (search-based 2-char teleport)
--   S   Treesitter jump (select whole node by label)
--   r   Remote operator (e.g. dr<label> deletes a remote text object)
--   R   Treesitter search (line-by-line node search)

return {
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    ---@type Flash.Config
    opts = {
      modes = {
        -- Disable the noisy 'f/F/t/T' enhancement; keep vanilla behavior.
        char = { enabled = false },
        -- Don't hijack '/' search by default (opt-in via S).
        search = { enabled = false },
      },
    },
    keys = {
      { 's', mode = { 'n', 'x', 'o' }, function() require('flash').jump() end, desc = 'Flash jump' },
      { 'S', mode = { 'n', 'x', 'o' }, function() require('flash').treesitter() end, desc = 'Flash treesitter' },
      { 'r', mode = 'o', function() require('flash').remote() end, desc = 'Remote flash' },
      { 'R', mode = { 'o', 'x' }, function() require('flash').treesitter_search() end, desc = 'Treesitter search' },
    },
  },
}
