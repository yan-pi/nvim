return {
  {
    'direnv/direnv.vim',
    lazy = false,
    init = function()
      vim.g.direnv_silent_load = 1
    end,
  },
}
