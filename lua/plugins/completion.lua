-- Autocompletion

--- Constants for completion behavior tuning
local DOC_AUTO_SHOW_DELAY_MS = 200 -- Delay before showing docs (prevents UI jank)
local DOC_UPDATE_DELAY_MS = 100 -- Delay between doc updates
local DOC_MAX_HEIGHT_RATIO = 0.5 -- Documentation window max height (50% of screen)
local DOC_MAX_WIDTH_RATIO = 0.4 -- Documentation window max width (40% of screen)
local COPILOT_PRIORITY_BOOST = 100 -- Score offset for Copilot completions
local LAZYDEV_PRIORITY_BOOST = 100 -- Score offset for LazyDev completions

return {
  {
    'saghen/blink.cmp',
    -- Load only when entering insert mode (saves ~30-50ms on startup)
    event = 'InsertEnter',
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
          winhighlight = 'Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None',
          draw = {
            columns = {
              { 'kind_icon' },
              { 'label', 'label_description', gap = 1 },
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
          auto_show_delay_ms = DOC_AUTO_SHOW_DELAY_MS, -- Small delay prevents UI jank during rapid typing
          update_delay_ms = DOC_UPDATE_DELAY_MS, -- Balanced update frequency
          treesitter_highlighting = true, -- Better syntax highlighting in docs
          window = {
            border = 'single',
            max_height = math.floor(vim.o.lines * DOC_MAX_HEIGHT_RATIO),
            max_width = math.floor(vim.o.columns * DOC_MAX_WIDTH_RATIO),
          },
        },
        ghost_text = {
          enabled = true,
        },
      },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono',
      },

      sources = {
        default = { 'copilot', 'avante', 'buffer', 'lsp', 'path', 'snippets', 'lazydev' },
        providers = {
          --- Copilot AI completion provider (prioritized with score boost)
          copilot = {
            name = 'copilot',
            module = 'blink-cmp-copilot',
            score_offset = COPILOT_PRIORITY_BOOST,
            async = true,
            --- Transform Copilot items to use custom icon kind
            --- @param items table[] List of completion items from Copilot
            --- @return table[] Transformed items with Copilot kind
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
          --- LazyDev completion provider for Neovim Lua API (prioritized)
          lazydev = { module = 'lazydev.integrations.blink', score_offset = LAZYDEV_PRIORITY_BOOST },
          --- Avante AI completion provider
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
