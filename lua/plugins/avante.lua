return {
  {
    'yetone/avante.nvim',
    event = 'VeryLazy',
    lazy = false,
    version = false,
    opts = {
      -- Provider configuration
      provider = 'copilot',
      auto_suggestions_provider = 'copilot',

      -- Behavior
      behaviour = {
        auto_suggestions = true,
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = false,
        support_paste_from_clipboard = true,
      },

      -- Mappings
      mappings = {
        --- @class AvanteConflictMappings
        diff = {
          ours = 'co',
          theirs = 'ct',
          all_theirs = 'ca',
          both = 'cb',
          cursor = 'cc',
          next = ']x',
          prev = '[x',
        },
        suggestion = {
          accept = '<C-y>',
          next = '<C-n>',
          prev = '<C-p>',
          dismiss = '<C-]>',
        },
        jump = {
          next = ']]',
          prev = '[[',
        },
        submit = {
          normal = '<CR>',
          insert = '<C-s>',
        },
        sidebar = {
          switch_windows = '<Tab>',
          reverse_switch_windows = '<S-Tab>',
        },
      },

      -- Hints and UI
      hints = { enabled = true },

      -- Windows configuration
      windows = {
        ---@type "right" | "left" | "top" | "bottom"
        position = 'right',
        wrap = true,
        width = 30,
        sidebar_header = {
          align = 'center',
          rounded = true,
        },
      },

      -- Highlights
      highlights = {
        ---@type AvanteConflictHighlights
        diff = {
          current = 'DiffText',
          incoming = 'DiffAdd',
        },
      },

      -- Diff settings
      diff = {
        autojump = true,
        ---@type string | fun(): any
        list_opener = 'copen',
      },
    },
    build = 'make',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'stevearc/dressing.nvim',
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      'nvim-tree/nvim-web-devicons',
      'zbirenbaum/copilot.lua',
      {
        'HakonHarnes/img-clip.nvim',
        event = 'VeryLazy',
        opts = {
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            use_absolute_path = true,
          },
        },
      },
      {
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { 'markdown', 'Avante' },
        },
        ft = { 'markdown', 'Avante' },
      },
    },
    keys = {
      -- Group descriptor
      { '<leader>i', desc = '+AI (Avante)', mode = { 'n', 'v' } },

      -- Ask/Chat
      {
        '<leader>ia',
        function()
          require('avante.api').ask()
        end,
        desc = 'Ask',
        mode = { 'n', 'v' },
      },

      -- Inline Edit (main feature!)
      {
        '<leader>ie',
        function()
          require('avante.api').edit()
        end,
        desc = 'Edit (Inline)',
        mode = 'v',
      },

      -- Refresh
      {
        '<leader>ir',
        function()
          require('avante.api').refresh()
        end,
        desc = 'Refresh',
      },

      -- Toggle
      {
        '<leader>it',
        function()
          require('avante.api').toggle()
        end,
        desc = 'Toggle',
      },
    },
  },
}
