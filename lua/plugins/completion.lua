-- Autocompletion

return {
  {
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      {
        'Kaiser-Yang/blink-cmp-avante',
      },
      {
        'giuxtaposition/blink-cmp-copilot',
      },
      -- Snippet Engine
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          {
            'rafamadriz/friendly-snippets',
            config = function()
              require('luasnip.loaders.from_vscode').lazy_load()
            end,
          },
        },
        opts = {},
      },
      'folke/lazydev.nvim',
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
      keymap = {
        -- Custom keymaps for intuitive completion navigation
        preset = 'none', -- Disable preset to use custom keymaps

        -- Tab to select next completion item
        ['<Tab>'] = { 'select_next', 'fallback' },

        -- Shift+Tab to select previous completion item
        ['<S-Tab>'] = { 'select_prev', 'fallback' },

        -- Enter to accept completion
        ['<CR>'] = { 'accept', 'fallback' },

        -- Useful keymaps from default preset
        ['<C-Space>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<C-e>'] = { 'hide' },
        ['<C-k>'] = { 'show_documentation', 'hide_documentation' },

        -- Alternative navigation with arrow keys
        ['<Up>'] = { 'select_prev', 'fallback' },
        ['<Down>'] = { 'select_next', 'fallback' },

        -- Ctrl+n/p for vim-style navigation
        ['<C-n>'] = { 'select_next', 'fallback' },
        ['<C-p>'] = { 'select_prev', 'fallback' },
      },

      -- appearance = {
      --   -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      --   -- Adjusts spacing to ensure icons are aligned
      --   nerd_font_variant = 'mono',
      -- },
      --
      completion = {
        menu = {
          border = 'single',
          -- border = vim.g.border_style,
          winhighlight = 'Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None',
          max_height = math.floor(vim.o.lines * 0.3),
          max_width = math.floor(vim.o.columns * 0.5),
          min_width = 40,
          min_height = 10,
          zindex = 100,
          --
          draw = {
            columns = {
              { 'kind_icon', color = '#ff8800' },
              { 'label', 'label_description', gap = 1, color = '#00ff88' },
            },
          },
        },
        -- menu = {
        --   border = 'rounded', -- Options: "none", "single", "double", "rounded", "solid"
        --   winhighlight = 'Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None',
        -- },
        -- By default, you may press `<c-space>` to show the documentation.
        -- Optionally, set `auto_show = true` to show the documentation after a delay.
        -- documentation = { auto_show = false, auto_show_delay_ms = 500 },
        --
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 0,
          update_delay_ms = 50,
          window = {
            border = 'single',
            max_height = math.floor(vim.o.lines * 0.5),
            max_width = math.floor(vim.o.columns * 0.4),
          },
        },
        ghost_text = {
          enabled = true,
        },
      },

      appearance = {
        kind_icons = kind_icons,
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        -- nerd_font_variant = 'mono',
        -- Theming for the completion menu
        -- Options: "classic", "flat", "atom", "vscode", "palenight", "tokyonight"
        -- theme = 'vscode',
        -- Custom highlights for the completion menu
        highlights = {
          -- Completion menu normal text
          BlinkCmpMenu = { fg = '#ffffff', bg = '#1e1e1e' },
          -- Completion menu border
          BlinkCmpMenuBorder = { fg = '#3e3e3e', bg = '#1e1e1e' },
          -- Selected item in the completion menu
          BlinkCmpMenuSelection = { fg = '#ffffff', bg = '#264f78' },
          -- Matched text in the completion menu
          BlinkCmpMenuMatch = { fg = '#569cd6', bg = '#1e1e1e' },
          -- Documentation window normal text
          BlinkCmpDoc = { fg = '#ffffff', bg = '#1e1e1e' },
          -- Documentation window border
          BlinkCmpDocBorder = { fg = '#3e3e3e', bg = '#1e1e1e' },
        },
      },

      sources = {
        default = { 'copilot', 'avante', 'buffer', 'lsp', 'path', 'snippets', 'lazydev' },
        providers = {
          copilot = {
            name = 'copilot',
            module = 'blink-cmp-copilot',
            score_offset = 100,
            async = true,
            transform_items = function(_, items)
              local CompletionItemKind = require('blink.cmp.types').CompletionItemKind
              local kind_idx = #CompletionItemKind + 1
              CompletionItemKind[kind_idx] = 'Copilot'
              for _, item in ipairs(items) do
                item.kind = kind_idx
              end
              return items
            end,
          },
          lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
          avante = {
            module = 'blink-cmp-avante',
            name = 'Avante',
            opts = {},
          },
        },
      },

      snippets = { preset = 'luasnip' },

      -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
      -- which automatically downloads a prebuilt binary when enabled.
      --
      -- By default, we use the Lua implementation instead, but you may enable
      -- the rust implementation via `'prefer_rust_with_warning'`
      --
      -- See :h blink-cmp-config-fuzzy for more information
      fuzzy = { implementation = 'prefer_rust_with_warning' },

      -- Shows a signature help window while you type arguments for a function
      signature = { enabled = true },
    },
  },
}
