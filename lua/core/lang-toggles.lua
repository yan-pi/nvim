-- Language support toggles
--
-- Enable/disable entire language stacks without deleting plugin files.
-- These are checked at startup by Lazy.nvim's `enabled` field.
--
-- To enable a language, change the value to `true` and restart Neovim.

vim.g.lang_enabled = vim.g.lang_enabled or {
  lean = false,
  r = false,
  scheme = false, -- Scheme/Racket/Fennel via Conjure
  haskell = false,
}
