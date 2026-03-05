-- Scheme (Lisp) support for SICP
-- Provides REPL-driven development via Conjure with MIT Scheme / Guile

return {
  -- Conjure: Interactive REPL environment for Lisp-family languages
  {
    'Olical/conjure',
    ft = { 'scheme', 'racket', 'fennel' },
    dependencies = {
      -- S-expression structural editing
      {
        'guns/vim-sexp',
        ft = { 'scheme', 'racket', 'fennel' },
      },
      {
        'tpope/vim-sexp-mappings-for-regular-people',
        ft = { 'scheme', 'racket', 'fennel' },
      },
    },
    init = function()
      -- Conjure configuration (set before plugin loads)
      -- Prefix for all Conjure mappings (uses localleader which is now comma)
      vim.g['conjure#mapping#prefix'] = '<localleader>'

      -- Only enable Conjure for Lisp-family filetypes
      vim.g['conjure#filetypes'] = { 'scheme', 'racket', 'fennel' }

      -- Scheme client configuration
      vim.g['conjure#client#scheme#stdio#command'] = 'mit-scheme'
      vim.g['conjure#client#scheme#stdio#prompt_pattern'] = '%d+ %]=> '

      -- Auto-start REPL when a Scheme file is opened
      vim.g['conjure#client_on_load'] = true

      -- Log buffer settings (REPL output window)
      vim.g['conjure#log#hud#enabled'] = true
      vim.g['conjure#log#hud#width'] = 0.42
      vim.g['conjure#log#hud#height'] = 0.38
      vim.g['conjure#log#wrap'] = true
    end,
  },

  -- Treesitter parser for Scheme
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { 'scheme' })
    end,
  },
}
