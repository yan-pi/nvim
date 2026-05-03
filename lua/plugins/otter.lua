-- Embedded LSP/completion/diagnostics inside code blocks of markdown,
-- quarto, rmd. Useful for blog drafting (indianboy.sh) and notebooks.
--
-- Auto-activates on supported filetypes; <leader>oa to toggle on demand.

return {
  {
    'jmbuhr/otter.nvim',
    ft = { 'markdown', 'quarto', 'rmd' },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {
      lsp = { hover = { border = 'single' } },
      buffers = {
        set_filetype = true,
        write_to_disk = false,
      },
      handle_leading_whitespace = true,
    },
    config = function(_, opts)
      local otter = require('otter')
      otter.setup(opts)

      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('otter-activate', { clear = true }),
        pattern = { 'markdown', 'quarto', 'rmd' },
        callback = function()
          pcall(otter.activate)
        end,
      })

      vim.keymap.set('n', '<leader>oa', function()
        otter.activate()
      end, { desc = '[O]tter [A]ctivate embedded LSP' })
    end,
  },
}
