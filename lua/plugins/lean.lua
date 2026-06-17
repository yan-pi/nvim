-- Lean 4 language support
-- Lean 4 is a theorem prover and dependently typed programming language.
-- The LSP is built into the lean4 binary itself (lake serve).
--
-- Tools:
--   * lean4 (nix) -> compiler, lake build tool, and LSP server
--   * lean.nvim   -> infoview, widgets, unicode abbreviations
--   * nvim-treesitter -> syntax highlighting

if not vim.g.lang_enabled.lean then
  return {}
end

return {
  -- lean.nvim provides infoview, widgets, and unicode abbreviations.
  -- We disable its LSP management (deprecated/broken) and use native vim.lsp.config.
  {
    'Julian/lean.nvim',
    ft = { 'lean' },
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- Optional: for infoview pin icons
      -- 'nvim-tree/nvim-web-devicons',
    },
    opts = {
      -- Disable lean.nvim's LSP handling (deprecated, use native vim.lsp.config instead)
      lsp = { enable = false },

      -- Enable default key mappings (<localleader> is \\ by default in Lean)
      mappings = true,

      -- Infoview (interactive goal state)
      infoview = {
        autoopen = true,
        width = 50,
        height = 12,
        orientation = 'vertical',
        horizontal_position = 'bottom',
        separate_tab = false,
      },

      -- Unicode abbreviation expansion (e.g., \a -> α, \-> -> →)
      abbreviations = {
        enable = true,
        leader = '\\',
        extra = {},
      },

      -- Mark standard library / dependency files as nomodifiable
      ft = {
        nomodifiable = {
          -- Default patterns cover stdlib and _target deps
        },
      },
    },
  },

  -- Configure Lean 4 LSP natively (modern approach, avoids lean.nvim deprecation)
  {
    'neovim/nvim-lspconfig',
    opts = function(_, opts)
      opts.servers = opts.servers or {}

      opts.servers.leanls = {
        filetypes = { 'lean' },
        root_markers = { 'lakefile.lean', 'lakefile.toml', '.git' },
        init_options = {
          -- Time (ms) between edits and elaboration. Lower = faster feedback, higher CPU.
          editDelay = 10,
          -- Signal that widgets are supported (needed for lean.nvim infoview)
          hasWidgets = true,
        },
        -- Lean 4 LSP uses lake serve, which must run from the project root
        -- nvim-lspconfig handles this via root_dir / cmd_cwd
      }
    end,
  },

  -- Auto-enable leanls for lean files (not managed by mason-lspconfig)
  {
    'neovim/nvim-lspconfig',
    init = function()
      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('lean-lsp-enable', { clear = true }),
        pattern = { 'lean' },
        callback = function(args)
          vim.lsp.enable('leanls', { bufnr = args.buf })
        end,
        desc = 'Enable leanls LSP for lean files',
      })
    end,
  },
}
