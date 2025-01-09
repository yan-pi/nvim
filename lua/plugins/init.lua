return {
  {
    "stevearc/conform.nvim",
    event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },
  {
    'vyfor/cord.nvim',
    build = './build || .\\build',
    event = 'VeryLazy',
    opts = {}, -- calls require('cord').setup()
  },
  {
    "luckasRanarison/tailwind-tools.nvim",
    name = "tailwind-tools",
    build = ":UpdateRemotePlugins",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-telescope/telescope.nvim", -- optional
      "neovim/nvim-lspconfig",         -- optional
    },
    opts = {}                          -- your configuration
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "github/copilot.vim" },                       -- or zbirenbaum/copilot.lua
      { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
    },
    build = "make tiktoken",                          -- Only on MacOS or Linux
    opts = {
      -- See Configuration section for options
    },
    -- See Commands section for default commands if you want to lazy load on them
  },
  {
    "windwp/nvim-ts-autotag",
    ft = {
      "astro",
      "glimmer",
      "handlebars",
      "html",
      "javascript",
      "javascriptreact",
      "markdown",
      "php",
      "rescript",
      "svelte",
      "typescriptreact",
      "typescript",
      "vue",
      "xml",
    },
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  {
    "MunifTanjim/prettier.nvim",
    lazy = false,
    config = function()
      local prettier = require "prettier"

      prettier.setup {
        bin = "prettierd",
        cli_options = {
          config_precedence = "prefer-file",
        },
        filetypes = {
          "css",
          "graphql",
          "html",
          "javascript",
          "javascriptreact",
          "json",
          "less",
          "markdown",
          "scss",
          "typescript",
          "typescriptreact",
          "yaml",
        },
      }

      vim.cmd [[
        augroup FormatAutogroup
          autocmd!
          autocmd BufWritePre *.js,*.jsx,*.json,*.md,*.html,*.css,*.scss,*.ts,*.tsx,*.yaml,*.yml,*.yaml,*.graphql :Prettier
        augroup END
      ]]
    end,
  },
  {
    "kdheepak/lazygit.nvim",
    lazy = true,
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
    }
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
  {
    "f-person/git-blame.nvim",
    event = "VeryLazy",
    opts = {
      enabled = true,
      message_template = " <author> • <summary> • <date> • <<sha>>",
      virtual_text_column = 1,
    }
  },
  {
    "ray-x/lsp_signature.nvim",
    event = "InsertEnter",
    config = function()
      require "lsp_signature".on_attach()
    end,
  },
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
  },
  {
    "folke/todo-comments.nvim",
    event = "BufReadPre",
    config = function()
      require("todo-comments").setup {}
    end,
  },
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
  },
  {
    "folke/twilight.nvim",
    cmd = "Twilight",
  },
  {
    "folke/which-key.nvim",
    event = "BufWinEnter",
    config = function()
      require("which-key").setup {}
    end,
  },
  {
    "folke/lsp-colors.nvim",
    event = "BufReadPre",
  },
  {
    "folke/lsp-trouble.nvim",
    cmd = "LspTrouble",
  },
  {
    "github/copilot.vim",
    lazy = false,
    config = function()                   -- Mapping tab is already used in NvChad
      vim.g.copilot_no_tab_map = true;    -- Disable tab mapping
      vim.g.copilot_assume_mapped = true; -- Assume that the mapping is already done
    end
  },
  { 'wakatime/vim-wakatime',            lazy = false },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server", "stylua",
        "html-lsp", "css-lsp", "prettier"
      },
    },
  },
  { 'williamboman/mason-lspconfig.nvim' },
  { 'mfussenegger/nvim-dap' },
  {
    'mrcjkb/rustaceanvim',
    version = '^5', -- Recommended
    lazy = false,   -- This plugin is already lazy
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim", "lua", "vimdoc",
        "html", "css"
      },
    },
  },
}
