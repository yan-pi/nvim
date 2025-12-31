-- Autoformat

return {
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'never' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
      -- Toggle auto-format on save
      {
        '<leader>uf',
        function()
          vim.g.autoformat_enabled = not vim.g.autoformat_enabled
          local status = vim.g.autoformat_enabled and 'enabled' or 'disabled'
          vim.notify('Auto-format on save: ' .. status, vim.log.levels.INFO)
        end,
        desc = 'Toggle auto-format on save',
      },
    },
    init = function()
      -- Enable auto-format by default
      vim.g.autoformat_enabled = true
    end,
    opts = {
      notify_on_error = false,
      formatters = {
        -- Configure prettier to use project config and ignore ESLint formatting rules
        prettier = {
          prepend_args = { '--config-precedence', 'prefer-file' },
        },
      },
      format_on_save = function(bufnr)
        -- Check global toggle
        if not vim.g.autoformat_enabled then
          return nil
        end

        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 500,
            lsp_format = 'never', -- Don't use LSP for formatting, use configured formatters only
          }
        end
      end,
      formatters_by_ft = {
        -- Lua formatting
        lua = { 'stylua' },

        -- JavaScript and TypeScript formatting
        -- Use prettier directly for better project config support
        javascript = { 'prettier' },
        javascriptreact = { 'prettier' },
        typescript = { 'prettier' },
        typescriptreact = { 'prettier' },

        -- Web technologies
        html = { 'prettier' },
        css = { 'prettier' },
        scss = { 'prettier' },

        -- JSON formatting
        json = { 'prettier' },
        jsonc = { 'prettier' },

        -- Markdown formatting
        markdown = { 'prettier' },

        -- YAML formatting
        yaml = { 'prettier' },
        yml = { 'prettier' },

        -- Python: Use Ruff for formatting (extremely fast, replaces black/isort)
        python = { 'ruff_format', 'ruff_organize_imports' },

        -- Rust: Use LSP formatting (rust_analyzer) as primary
        -- rust = {}, -- Handled by LSP

        -- Shell scripts
        sh = { 'shfmt' }, -- Can be installed via Mason if needed
        bash = { 'shfmt' },
      },
    },
  },
}