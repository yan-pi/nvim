return {
  -- Load WakaTime after UI is ready (time tracking doesn't need to be immediate)
  { 'wakatime/vim-wakatime', event = 'VeryLazy' },
  {
    'm4xshen/hardtime.nvim',
    lazy = false,
    dependencies = { 'MunifTanjim/nui.nvim' },
    opts = {
      enabled = true, -- Start with the plugin disabled
    },
  },
}
