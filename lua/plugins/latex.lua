-- LaTeX support: VimTeX (compile/SyncTeX/motions) + LuaSnip math snippets + nabla math preview
-- Toolchain (texlive, ghostscript, skim) is provisioned via nix-darwin.
--
-- Buffer-local keybinds (only active in .tex files), all under <leader>l*:
--   <leader>ll  Compile (toggle continuous, latexmk -pvc)
--   <leader>lo  Compile One-shot
--   <leader>lk  Kill compilation
--   <leader>lv  View PDF (Skim)
--   <leader>lt  TOC navigator
--   <leader>le  Errors quickfix
--   <leader>lc  Clean aux files
--   <leader>li  Info
--   <leader>lp  math Preview popup (nabla)
--   <leader>lP  math preview toggle inline (nabla virt text)

return {
  -- Formatter: latexindent
  {
    'stevearc/conform.nvim',
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.tex = { 'latexindent' }
      opts.formatters_by_ft.plaintex = { 'latexindent' }
    end,
  },

  -- Core LaTeX plugin: compilation, SyncTeX, TOC, motions, text objects
  {
    'lervag/vimtex',
    lazy = false, -- VimTeX must hook into FileType events at startup
    init = function()
      -- PDF viewer: Skim (macOS, supports forward + inverse SyncTeX)
      vim.g.vimtex_view_method = 'skim'
      vim.g.vimtex_view_skim_sync = 1 -- Activate forward search after compile
      vim.g.vimtex_view_skim_activate = 1 -- Bring Skim to focus on view
      vim.g.vimtex_view_skim_reading_bar = 1

      -- Compiler: latexmk (default), nonstopmode for non-blocking errors
      vim.g.vimtex_compiler_method = 'latexmk'
      vim.g.vimtex_compiler_latexmk = {
        aux_dir = '',
        out_dir = '',
        callback = 1,
        continuous = 1,
        executable = 'latexmk',
        hooks = {},
        options = {
          '-verbose',
          '-file-line-error',
          '-synctex=1',
          '-interaction=nonstopmode',
        },
      }

      -- Quickfix: don't auto-open on warnings (only on errors)
      vim.g.vimtex_quickfix_mode = 0
      vim.g.vimtex_quickfix_open_on_warning = 0

      -- Conceal: disabled (let nabla.nvim handle math preview instead)
      vim.g.vimtex_syntax_conceal_disable = 1

      -- Disable VimTeX's default <localleader>l* mappings — we use <leader>l*
      -- via a buffer-local autocmd instead (see config below). Safer than
      -- relying on localleader timing across plugins.
      vim.g.vimtex_mappings_enabled = 0

      -- Use treesitter for folding/syntax where available
      vim.g.vimtex_fold_enabled = 0 -- Disable VimTeX folding (perf on large docs)
    end,
    config = function()
      -- Buffer-local keybinds for .tex buffers, all under <leader>l*
      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('latex-keymaps', { clear = true }),
        pattern = { 'tex', 'plaintex' },
        callback = function(ev)
          local map = function(lhs, rhs, desc)
            vim.keymap.set('n', lhs, rhs, { buffer = ev.buf, desc = 'LaTeX: ' .. desc, silent = true })
          end

          -- Compile / build lifecycle
          map('<leader>ll', '<cmd>VimtexCompile<cr>', 'Compile (toggle continuous)')
          map('<leader>lo', '<cmd>VimtexCompileSS<cr>', 'Compile One-shot')
          map('<leader>lk', '<cmd>VimtexStop<cr>', 'Kill compilation')
          map('<leader>lc', '<cmd>VimtexClean<cr>', 'Clean aux files')

          -- View / navigate
          map('<leader>lv', '<cmd>VimtexView<cr>', 'View PDF (Skim)')
          map('<leader>lt', '<cmd>VimtexTocOpen<cr>', 'TOC navigator')
          map('<leader>le', '<cmd>VimtexErrors<cr>', 'Errors quickfix')
          map('<leader>li', '<cmd>VimtexInfo<cr>', 'Info')

          -- Math preview (nabla.nvim)
          map('<leader>lp', function()
            require('nabla').popup()
          end, 'math Preview popup')
          map('<leader>lP', function()
            require('nabla').toggle_virt()
          end, 'math Preview toggle inline')
        end,
      })
    end,
  },

  -- Math-mode snippets ported from Gilles Castel's setup
  -- Provides auto-snippets like 'mk' → inline math, 'dm' → display math, '//' → fraction, etc.
  {
    'iurimateus/luasnip-latex-snippets.nvim',
    dependencies = { 'L3MON4D3/LuaSnip', 'lervag/vimtex' },
    ft = { 'tex', 'markdown' },
    config = function()
      require('luasnip-latex-snippets').setup {
        use_treesitter = false, -- Use VimTeX's syntax-based math zone detection
        allow_on_markdown = true,
      }
      require('luasnip').config.set_config {
        enable_autosnippets = true,
        store_selection_keys = '<Tab>',
      }
    end,
  },

  -- Inline math preview: render LaTeX math as Unicode in floating windows or virtual text
  -- Keybinds are set buffer-local in vimtex's autocmd above (<leader>lp / <leader>lP).
  {
    'jbyuki/nabla.nvim',
    ft = { 'tex', 'markdown' },
  },
}
