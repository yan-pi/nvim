-- Pin Mason-installed tool versions across machines.
--
-- mason-lock.json is the Mason equivalent of lazy-lock.json. Commit it
-- alongside the config so a clone on a different machine installs the
-- exact same versions of rust-analyzer / basedpyright / etc.
--
-- Workflow:
--   :MasonLock         write current versions to mason-lock.json
--   :MasonLockRestore  reinstall from mason-lock.json
--
-- The lockfile is read on startup; any tool drift triggers a
-- prompt-free reinstall to the locked version.

return {
  {
    'Crashdummyy/mason-lock.nvim',
    event = 'VeryLazy',
    opts = {
      lockfile_path = vim.fn.stdpath('config') .. '/mason-lock.json',
    },
  },
}
