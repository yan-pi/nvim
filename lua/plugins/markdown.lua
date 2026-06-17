return {
  -- Formatter: project-aware (biome → prettier)
  {
    'stevearc/conform.nvim',
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      local detect = require('core.formatting-utils').detect_formatter
      opts.formatters_by_ft.markdown = function(bufnr)
        return detect(bufnr, {
          { files = { 'biome.json', 'biome.jsonc' }, formatters = { 'biome' } },
          {
            files = { '.prettierrc', '.prettierrc.json', '.prettierrc.js', '.prettierrc.yml', 'prettier.config.js', 'prettier.config.cjs' },
            formatters = { 'prettierd', 'prettier', stop_after_first = true },
          },
        }, {
          default = { 'prettierd', 'prettier', stop_after_first = true },
        })
      end
    end,
  },

  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    build = 'cd app && corepack yarn install --frozen-lockfile',
    init = function()
      vim.g.mkdp_filetypes = { 'markdown' }
    end,
    ft = { 'markdown' },
  },
  {
    'Kicamon/markdown-table-mode.nvim',
    ft = { 'markdown' },
    config = function()
      require('markdown-table-mode').setup()
    end,
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    opts = {
      file_types = { 'markdown', 'Avante' },
    },
    ft = { 'markdown', 'Avante' },
    config = function(_, opts)
      require('render-markdown').setup(opts)
      vim.keymap.set('n', '<leader>mr', function()
        vim.cmd 'RenderMarkdown toggle'
      end, { desc = 'Toggle render-markdown' })
    end,
  },
  {
    'Thiago4532/mdmath.nvim',
    ft = 'markdown',
    build = function()
      require('mdmath.build').build_lazy()
    end,
    config = function()
      require('mdmath').setup {
        filetypes = { 'markdown' },
        preview = { auto = true },
      }
      vim.keymap.set('n', '<leader>mm', '<cmd>MdMathToggle<cr>', { desc = 'Toggle mdmath' })
    end,
  },
  -- {
  --   "OXY2DEV/markview.nvim",
  --   lazy = false,
  -- },
}
