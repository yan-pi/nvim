-- Auto-close brackets, quotes, and parentheses

return {
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    dependencies = {
      'saghen/blink.cmp',
    },
    config = function()
      local autopairs = require('nvim-autopairs')

      autopairs.setup({
        check_ts = true, -- Enable treesitter integration
        ts_config = {
          lua = { 'string' }, -- Don't add pairs in lua string treesitter nodes
          javascript = { 'template_string' }, -- Don't add pairs in JS template strings
          java = false, -- Disable for java
        },
        disable_filetype = { 'TelescopePrompt', 'spectre_panel' },
        disable_in_macro = true, -- Disable when recording or executing a macro
        disable_in_visualblock = false, -- Disable when in visual block mode
        disable_in_replace_mode = true, -- Disable in replace mode
        ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
        enable_moveright = true,
        enable_afterquote = true, -- Add bracket pairs after quote
        enable_check_bracket_line = true, -- Check bracket in same line
        enable_bracket_in_quote = true,
        enable_abbr = false, -- Trigger abbreviation
        break_undo = true, -- Switch for basic rule break undo sequence
        check_comma = true,
        map_cr = true,
        map_bs = true, -- Map <BS> key
        map_c_h = false, -- Map <C-h> key to delete a pair
        map_c_w = false, -- Map <C-w> to delete a pair if possible
      })

      -- Add custom rules for better Lua experience
      local Rule = require('nvim-autopairs.rule')
      local cond = require('nvim-autopairs.conds')

      -- Add spaces inside brackets for function calls
      autopairs.add_rules({
        Rule(' ', ' ')
          :with_pair(function(opts)
            local pair = opts.line:sub(opts.col - 1, opts.col)
            return vim.tbl_contains({ '()', '[]', '{}' }, pair)
          end),
        Rule('( ', ' )')
          :with_pair(function() return false end)
          :with_move(function(opts)
            return opts.prev_char:match('.%)') ~= nil
          end)
          :use_key(')'),
        Rule('{ ', ' }')
          :with_pair(function() return false end)
          :with_move(function(opts)
            return opts.prev_char:match('.%}') ~= nil
          end)
          :use_key('}'),
        Rule('[ ', ' ]')
          :with_pair(function() return false end)
          :with_move(function(opts)
            return opts.prev_char:match('.%]') ~= nil
          end)
          :use_key(']')
      })
    end,
  },
}