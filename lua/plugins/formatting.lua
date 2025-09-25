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
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 500,
            lsp_format = 'fallback',
          }
        end
      end,
      formatters_by_ft = {
        -- Lua formatting
        lua = { 'stylua' },

        -- JavaScript and TypeScript formatting
        -- Use prettierd for speed, fallback to prettier
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
        javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        typescript = { 'prettierd', 'prettier', stop_after_first = true },
        typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },

        -- Web technologies
        html = { 'prettierd', 'prettier', stop_after_first = true },
        css = { 'prettierd', 'prettier', stop_after_first = true },
        scss = { 'prettierd', 'prettier', stop_after_first = true },

        -- JSON formatting
        json = { 'prettierd', 'prettier', stop_after_first = true },
        jsonc = { 'prettierd', 'prettier', stop_after_first = true },

        -- Markdown formatting
        markdown = { 'prettierd', 'prettier', stop_after_first = true },

        -- YAML formatting
        yaml = { 'prettierd', 'prettier', stop_after_first = true },
        yml = { 'prettierd', 'prettier', stop_after_first = true },

        -- Python: Use LSP formatting (pylsp) as primary, with lsp_format fallback
        -- python = {}, -- Handled by LSP

        -- Rust: Use LSP formatting (rust_analyzer) as primary
        -- rust = {}, -- Handled by LSP

        -- Shell scripts
        sh = { 'shfmt' }, -- Can be installed via Mason if needed
        bash = { 'shfmt' },
      },
    },
  },
}