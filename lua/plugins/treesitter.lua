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
        'haskell',
        'go',
        -- cabal parser not available in nvim-treesitter
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
        -- LaTeX
        'latex',
        'bibtex',
      },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Disable highlighting in large files for better performance
        disable = function(lang, buf)
          local max_filesize = 100 * 1024 -- 100KB
          local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
          -- Also disable in minified files (very long lines)
          local max_line_length = 500
          local line_count = vim.api.nvim_buf_line_count(buf)
          -- Check first 100 lines for performance
          local lines_to_check = math.min(100, line_count)
          local lines = vim.api.nvim_buf_get_lines(buf, 0, lines_to_check, false)
          for _, line in ipairs(lines) do
            if #line > max_line_length then
              return true
            end
          end
          return false
        end,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)

      -- Neovim 0.12 dropped the `all = false` opt on query.add_directive/add_predicate,
      -- so handlers now always receive `match: table<integer, TSNode[]>` (a list per
      -- capture) instead of a single TSNode. nvim-treesitter master still indexes
      -- `match[id]` as a TSNode, blowing up in render-markdown.nvim's injection parse.
      -- Re-register the affected directives/predicates with list-aware handlers until
      -- upstream catches up.
      local q = require 'vim.treesitter.query'
      local force = { force = true }

      local function first_node(match, id)
        local v = match[id]
        if type(v) == 'table' then
          return v[1]
        end
        return v
      end

      local html_script_type_languages = {
        importmap = 'json',
        module = 'javascript',
        ['application/ecmascript'] = 'javascript',
        ['text/ecmascript'] = 'javascript',
      }

      local non_filetype_match_injection_language_aliases = {
        ex = 'elixir',
        pl = 'perl',
        sh = 'bash',
        uxn = 'uxntal',
        ts = 'typescript',
      }

      local function get_parser_from_markdown_info_string(alias)
        local m = vim.filetype.match { filename = 'a.' .. alias }
        return m or non_filetype_match_injection_language_aliases[alias] or alias
      end

      q.add_directive('set-lang-from-info-string!', function(match, _, bufnr, pred, metadata)
        local node = first_node(match, pred[2])
        if not node then
          return
        end
        local alias = vim.treesitter.get_node_text(node, bufnr):lower()
        metadata['injection.language'] = get_parser_from_markdown_info_string(alias)
      end, force)

      q.add_directive('set-lang-from-mimetype!', function(match, _, bufnr, pred, metadata)
        local node = first_node(match, pred[2])
        if not node then
          return
        end
        local value = vim.treesitter.get_node_text(node, bufnr)
        local configured = html_script_type_languages[value]
        if configured then
          metadata['injection.language'] = configured
        else
          local parts = vim.split(value, '/', {})
          metadata['injection.language'] = parts[#parts]
        end
      end, force)

      q.add_directive('downcase!', function(match, _, bufnr, pred, metadata)
        local id = pred[2]
        local node = first_node(match, id)
        if not node then
          return
        end
        local text = vim.treesitter.get_node_text(node, bufnr, { metadata = metadata[id] }) or ''
        if not metadata[id] then
          metadata[id] = {}
        end
        metadata[id].text = string.lower(text)
      end, force)

      q.add_predicate('nth?', function(match, _, _, pred)
        local node = first_node(match, pred[2])
        local n = tonumber(pred[3])
        if node and node:parent() and node:parent():named_child_count() > n then
          return node:parent():named_child(n) == node
        end
        return false
      end, force)

      q.add_predicate('kind-eq?', function(match, _, _, pred)
        local node = first_node(match, pred[2])
        if not node then
          return true
        end
        local types = { unpack(pred, 3) }
        return vim.tbl_contains(types, node:type())
      end, force)

      q.add_predicate('is?', function(match, _, bufnr, pred)
        local node = first_node(match, pred[2])
        if not node then
          return true
        end
        local locals = require 'nvim-treesitter.locals'
        local types = { unpack(pred, 3) }
        local _, _, kind = locals.find_definition(node, bufnr)
        return vim.tbl_contains(types, kind)
      end, force)

      q.add_predicate('has-ancestor?', function(match, _, _, pred)
        local node = first_node(match, pred[2])
        if not node then
          return true
        end
        local ancestor_types = { unpack(pred, 3) }
        local parent = node:parent()
        while parent do
          if vim.tbl_contains(ancestor_types, parent:type()) then
            return true
          end
          parent = parent:parent()
        end
        return false
      end, force)

      q.add_predicate('has-parent?', function(match, _, _, pred)
        local node = first_node(match, pred[2])
        if not node then
          return true
        end
        local parent_types = { unpack(pred, 3) }
        local parent = node:parent()
        if parent and vim.tbl_contains(parent_types, parent:type()) then
          return true
        end
        return false
      end, force)
    end,
    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  },
}