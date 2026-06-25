return {
  -- Load WakaTime after UI is ready (time tracking doesn't need to be immediate)
  { 'wakatime/vim-wakatime', event = 'VeryLazy' },
  {
    'nvzone/showkeys',
    cmd = 'ShowkeysToggle',
    opts = {
      timeout = 1,
      maxkeys = 5,
      -- more opts
    },
  },
}
