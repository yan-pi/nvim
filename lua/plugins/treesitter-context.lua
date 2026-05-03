-- Sticky header showing the enclosing scope (function, struct, impl,
-- match arm, etc.) at the top of the window. Critical for long Rust/Go
-- files where the cursor drifts far below the signature.

return {
  {
    'nvim-treesitter/nvim-treesitter-context',
    event = 'BufReadPost',
    opts = {
      max_lines = 3,
      multiline_threshold = 1,
      trim_scope = 'outer',
      mode = 'cursor',
      separator = nil,
    },
    keys = {
      {
        '<leader>ux',
        function()
          require('treesitter-context').toggle()
        end,
        desc = 'Toggle context header',
      },
    },
  },
}
