-- Lua language support
--
-- Stack:
--   * lazydev (LSP)  -> Neovim config annotations, runtime API signatures
--   * lua_ls (LSP)   -> Lua language server
--   * stylua         -> formatter
--   * treesitter     -> syntax highlighting (lua, luadoc)
--
-- Nix installs: lua5_4
-- Mason installs: lua_ls, stylua

return {
  -- LSP: lazydev for Neovim config annotations
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },

  -- LSP: lua_ls
  {
    'neovim/nvim-lspconfig',
    opts = function(_, opts)
      opts.servers = opts.servers or {}

      opts.servers.lua_ls = {
        settings = {
          Lua = {
            completion = {
              callSnippet = 'Replace',
            },
            -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
            -- diagnostics = { disable = { 'missing-fields' } },
          },
        },
      }
    end,
  },

  -- Formatter: stylua
  {
    'stevearc/conform.nvim',
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.lua = { 'stylua' }
    end,
  },

  -- Treesitter: parsers lua, luadoc
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { 'lua', 'luadoc' })
    end,
  },
}
