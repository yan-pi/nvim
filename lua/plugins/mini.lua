-- Collection of various small independent plugins/modules

return {
  {
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      -- require('mini.ai').setup { n_lines = 500 }

      -- File explorer with column view
      require('mini.files').setup {
        options = {
          use_as_default_explorer = true, -- Keep alongside netrw/telescope
        },
        mappings = {
          close = '<Esc>', -- Escape to close (intuitive)
          go_in = 'l', -- l to enter/open (vim-like)
          go_in_plus = 'L', -- L for advanced entry
          go_out = 'h', -- h for parent directory (vim-like)
          go_out_plus = 'H', -- H for advanced parent
          mark_goto = "'", -- Bookmark navigation
          mark_set = 'm', -- Bookmark setting
          reset = '<BS>', -- Backspace reset
          reveal_cwd = '@', -- Reveal cwd
          show_help = 'g?', -- Help
          synchronize = '=', -- Sync (ESSENTIAL for saving changes)
          trim_left = '<', -- Trim left
          trim_right = '>', -- Trim right
        },
        windows = {
          width_focus = 40, -- Wider focused window for better visibility
          width_nofocus = 30, -- Narrower unfocused window to save space
          preview = true, -- Enable file preview (useful for many file types)
        },
      }

      -- Add buffer-local Enter key support for mini.files
      vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesBufferCreate',
        callback = function(args)
          local buf_id = args.data.buf_id
          -- Add Enter as intuitive alternative to 'l'
          vim.keymap.set('n', '<CR>', 'l', {
            buffer = buf_id,
            remap = true,
            desc = 'Enter directory/open file',
          })
        end,
      })

      -- Enhanced Git status integration for mini.files with directory marking
      local nsMiniFiles = vim.api.nvim_create_namespace 'mini_files_git'
      local autocmd = vim.api.nvim_create_autocmd

      -- Cache for git status
      local gitStatusCache = {}
      local cacheTimeout = 2000 -- in milliseconds
      local uv = vim.uv or vim.loop

      local function isSymlink(path)
        local stat = uv.fs_lstat(path)
        return stat and stat.type == 'link'
      end

      ---@param status string
      ---@param is_symlink boolean
      ---@return string symbol, string hlGroup
      local function mapSymbols(status, is_symlink)
        local statusMap = {
          -- stylua: ignore start
          [' M'] = { symbol = '•', hlGroup  = 'MiniDiffSignChange'}, -- Modified in the working directory
          ['M '] = { symbol = '✹', hlGroup  = 'MiniDiffSignChange'}, -- modified in index
          ['MM'] = { symbol = '≠', hlGroup  = 'MiniDiffSignChange'}, -- modified in both working tree and index
          ['A '] = { symbol = '+', hlGroup  = 'MiniDiffSignAdd'   }, -- Added to the staging area, new file
          ['AA'] = { symbol = '≈', hlGroup  = 'MiniDiffSignAdd'   }, -- file is added in both working tree and index
          ['D '] = { symbol = '-', hlGroup  = 'MiniDiffSignDelete'}, -- Deleted from the staging area
          ['AM'] = { symbol = '⊕', hlGroup  = 'MiniDiffSignChange'}, -- added in working tree, modified in index
          ['AD'] = { symbol = '-•', hlGroup = 'MiniDiffSignChange'}, -- Added in the index and deleted in the working directory
          ['R '] = { symbol = '→', hlGroup  = 'MiniDiffSignChange'}, -- Renamed in the index
          ['U '] = { symbol = '‖', hlGroup  = 'MiniDiffSignChange'}, -- Unmerged path
          ['UU'] = { symbol = '⇄', hlGroup  = 'MiniDiffSignAdd'   }, -- file is unmerged
          ['UA'] = { symbol = '⊕', hlGroup  = 'MiniDiffSignAdd'   }, -- file is unmerged and added in working tree
          ['??'] = { symbol = '?', hlGroup  = 'MiniDiffSignDelete'}, -- Untracked files
          ['!!'] = { symbol = '!', hlGroup  = 'MiniDiffSignChange'}, -- Ignored files
          -- stylua: ignore end
        }

        local result = statusMap[status] or { symbol = '?', hlGroup = 'NonText' }
        local gitSymbol = result.symbol
        local gitHlGroup = result.hlGroup

        local symlinkSymbol = is_symlink and '↩' or ''

        -- Combine symlink symbol with Git status if both exist
        local combinedSymbol = (symlinkSymbol .. gitSymbol):gsub('^%s+', ''):gsub('%s+$', '')
        -- Change the color of the symlink icon from "MiniDiffSignDelete" to something else
        local combinedHlGroup = is_symlink and 'MiniDiffSignDelete' or gitHlGroup

        return combinedSymbol, combinedHlGroup
      end

      ---@param cwd string
      ---@param callback function
      ---@return nil
      local function fetchGitStatus(cwd, callback)
        local clean_cwd = cwd:gsub('^minifiles://%d+/', '')
        ---@param content table
        local function on_exit(content)
          if content.code == 0 then
            callback(content.stdout)
          end
        end
        ---@see vim.system
        vim.system({ 'git', 'status', '--ignored', '--porcelain' }, { text = true, cwd = clean_cwd }, on_exit)
      end

      -- Enhanced git status parsing with directory hierarchy support
      ---@param content string
      ---@return table
      local function parseGitStatus(content)
        local gitStatusMap = {}
        -- lua match is faster than vim.split (in my experience )
        for line in content:gmatch '[^\r\n]+' do
          local status, filePath = string.match(line, '^(..)%s+(.*)')
          if status and filePath then
            -- Split the file path into parts
            local parts = {}
            for part in filePath:gmatch '[^/]+' do
              table.insert(parts, part)
            end
            -- Start with the root directory
            local currentKey = ''
            for i, part in ipairs(parts) do
              if i > 1 then
                -- Concatenate parts with a separator to create a unique key
                currentKey = currentKey .. '/' .. part
              else
                currentKey = part
              end
              -- If it's the last part, it's a file, so add it with its status
              if i == #parts then
                gitStatusMap[currentKey] = status
              else
                -- If it's not the last part, it's a directory. Check if it exists, if not, add it.
                if not gitStatusMap[currentKey] then
                  gitStatusMap[currentKey] = status
                end
              end
            end
          end
        end
        return gitStatusMap
      end

      ---@param buf_id integer
      ---@param gitStatusMap table
      ---@return nil
      local function updateMiniWithGit(buf_id, gitStatusMap)
        vim.schedule(function()
          local nlines = vim.api.nvim_buf_line_count(buf_id)
          local cwd = vim.fs.root(buf_id, '.git')
          local escapedcwd = cwd and vim.pesc(cwd)
          escapedcwd = vim.fs.normalize(escapedcwd)

          for i = 1, nlines do
            local entry = MiniFiles.get_fs_entry(buf_id, i)
            if not entry then
              break
            end
            local relativePath = entry.path:gsub('^' .. escapedcwd .. '/', '')
            local status = gitStatusMap[relativePath]

            if status then
              local symbol, hlGroup = mapSymbols(status, isSymlink(entry.path))
              vim.api.nvim_buf_set_extmark(buf_id, nsMiniFiles, i - 1, 0, {
                sign_text = symbol,
                sign_hl_group = hlGroup,
                priority = 2,
              })

              -- Text highlighting for git status items
              local line = vim.api.nvim_buf_get_lines(buf_id, i - 1, i, false)[1]
              -- Find the name position accounting for potential icons
              local nameStartCol = line:find(vim.pesc(entry.name)) or 0

              if nameStartCol > 0 then
                vim.api.nvim_buf_set_extmark(buf_id, nsMiniFiles, i - 1, nameStartCol - 1, {
                  end_col = nameStartCol + #entry.name - 1,
                  hl_group = hlGroup,
                })
              end
            end
          end
        end)
      end

      ---@param buf_id integer
      ---@return nil
      local function updateGitStatus(buf_id)
        if not vim.fs.root(buf_id, '.git') then
          return
        end
        local cwd = vim.fs.root(buf_id, '.git')
        local currentTime = os.time()

        if gitStatusCache[cwd] and currentTime - gitStatusCache[cwd].time < cacheTimeout then
          updateMiniWithGit(buf_id, gitStatusCache[cwd].statusMap)
        else
          fetchGitStatus(cwd, function(content)
            local gitStatusMap = parseGitStatus(content)
            gitStatusCache[cwd] = {
              time = currentTime,
              statusMap = gitStatusMap,
            }
            updateMiniWithGit(buf_id, gitStatusMap)
          end)
        end
      end

      ---@return nil
      local function clearCache()
        gitStatusCache = {}
      end

      local function augroup(name)
        return vim.api.nvim_create_augroup('MiniFiles_' .. name, { clear = true })
      end

      autocmd('User', {
        group = augroup 'start',
        pattern = 'MiniFilesExplorerOpen',
        callback = function()
          local bufnr = vim.api.nvim_get_current_buf()
          updateGitStatus(bufnr)
        end,
      })

      autocmd('User', {
        group = augroup 'close',
        pattern = 'MiniFilesExplorerClose',
        callback = function()
          clearCache()
        end,
      })

      autocmd('User', {
        group = augroup 'update',
        pattern = 'MiniFilesBufferUpdate',
        callback = function(args)
          local bufnr = args.data.buf_id
          local cwd = vim.fs.root(bufnr, '.git')
          if gitStatusCache[cwd] then
            updateMiniWithGit(bufnr, gitStatusCache[cwd].statusMap)
          end
        end,
      })

      -- Move lines and blocks with Alt+hjkl
      require('mini.move').setup() -- Uses default Alt+hjkl mappings

      -- Start screen
      require('mini.starter').setup()

      -- Navigate with ][ shortcuts (]b for next buffer, etc.)
      require('mini.bracketed').setup()

      -- Indent scope visualization
      -- require('mini.indentscope').setup()

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font
      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end

      -- Mini.files - File Explorer
      vim.keymap.set('n', '<leader>e', function()
        local current_file = vim.api.nvim_buf_get_name(0)
        -- Check if current buffer has a valid file path
        if current_file == '' or current_file:match '^%w+://' then
          -- Open at current working directory if no valid file or special buffer
          MiniFiles.open()
        else
          -- Open at current file's location
          MiniFiles.open(current_file)
        end
      end, { desc = 'File [E]xplorer (current file)' })

      vim.keymap.set('n', '<leader>E', function()
        MiniFiles.open()
      end, { desc = 'File [E]xplorer (cwd)' })

      -- Note: Mini.pick removed - using snacks.nvim for all picker functionality
      -- Mini.files provides excellent file management, complementing snacks pickers

      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
    end,
  },
}
