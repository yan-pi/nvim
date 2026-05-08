-- Vault agenda — org-mode-style cross-file task view backed by Snacks.picker.
-- Logic lives in `lua/vault/agenda.lua`; this file wires config + keymaps.
--
-- To add files to the agenda, append paths to the `files` list below.
-- Equivalent to `org-agenda-files` in Emacs.
return {
  {
    'folke/snacks.nvim',
    optional = true,
    init = function()
      require('vault.agenda').setup {
        files = {
          '~/www/vault/00-Index/001-Planning.md',
          -- add more files here, e.g.:
          -- '~/www/vault/40-Logbook/4001-Daily/2026-05-08.md',
        },
      }
    end,
    keys = {
      {
        '<leader>za',
        function()
          require('vault.agenda').open()
        end,
        desc = 'Vault [A]genda (active)',
      },
      {
        '<leader>zA',
        function()
          require('vault.agenda').open { all = true, title = 'Vault Agenda — all' }
        end,
        desc = 'Vault [A]genda (all incl. done)',
      },
      {
        '<leader>zi',
        function()
          require('vault.agenda').open { filter = { DOING = true }, title = 'Vault DOING' }
        end,
        desc = 'Vault DOING',
      },
      {
        '<leader>zw',
        function()
          require('vault.agenda').open { filter = { WAITING = true }, title = 'Vault WAITING' }
        end,
        desc = 'Vault WAITING',
      },
      {
        '<leader>zT',
        function()
          require('vault.agenda').open { filter = { TODO = true }, title = 'Vault TODO' }
        end,
        desc = 'Vault TODO',
      },
      {
        '<leader>zx',
        function()
          require('vault.agenda').cycle()
        end,
        desc = 'Cycle task status under cursor',
      },
    },
  },
}
