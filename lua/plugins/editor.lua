-- Editor enhancement plugins

return {
  -- Detect tabstop and shiftwidth automatically
  'NMAC427/guess-indent.nvim',

  -- Highlight todo, notes, etc in comments
  {
    'folke/todo-comments.nvim',
    -- Load when opening files (only needs to highlight actual buffer content)
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false }
  },
}