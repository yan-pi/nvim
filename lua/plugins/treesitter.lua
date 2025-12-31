-- Highlight, edit, and navigate code

return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    opts = {
      -- Comprehensive parser list to prevent runtime downloads
      -- Includes all languages from LSP config + common web/config formats
      ensure_installed = {
        -- Core/Required parsers
        'bash',
        'c',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
        -- Programming languages (from LSP config)
        'rust',
        'javascript',
        'typescript',
        'tsx',
        'python',
        'json',
        -- Note: jsonc removed due to archive corruption (json parser handles .jsonc files)
        -- Web development
        'css',
        'scss',
        -- Note: tailwindcss parser doesn't exist (Tailwind uses CSS/HTML syntax)
        --       Use tailwindcss-language-server for autocomplete instead
        -- Config/Data formats
        'yaml',
        'toml',
        'xml',
        -- Additional useful parsers
        'regex',
        'gitignore',
        'gitcommit',
        'git_rebase',
        'comment',
      },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  },
}