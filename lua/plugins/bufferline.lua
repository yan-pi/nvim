return {
  {
    'akinsho/bufferline.nvim',
    dependencies = 'kyazdani42/nvim-web-devicons',
    config = function()
      local status_ok, bufferline = pcall(require, 'bufferline')
      if not status_ok then
        return
      end

      vim.opt.termguicolors = true

      --- Constants for buffer management
      local INITIAL_BUFFER_INDEX = 1 -- Default active index when tab is created
      local MIN_BUFFER_INDEX = 1 -- Minimum valid buffer index (1-based indexing)

      -- Proper buffer-to-tab tracking using autocmds and persistent state

      --- @class TabBufferData
      --- @field buffers integer[] List of buffer numbers in this tab
      --- @field active_index integer Currently active buffer index (1-based)

      --- @class TabScopedBuffersModule
      --- @field tab_buffers table<integer, TabBufferData> Maps tab_id -> tab buffer data
      --- @field version integer Cache version for tracking changes
      local M = {}
      M.tab_buffers = {} -- Maps tab_id -> {buffers = {buf1, buf2, ...}, active_index = 1}
      M.version = 0

      --- Initialize tab buffer tracking for a given tabpage
      --- @param tabpage? integer Optional tabpage number (defaults to current tab)
      function M.init_tab(tabpage)
        tabpage = tabpage or vim.api.nvim_get_current_tabpage()
        if not M.tab_buffers[tabpage] then
          M.tab_buffers[tabpage] = {
            buffers = {},
            active_index = INITIAL_BUFFER_INDEX,
          }
        end
      end

      --- Check if a buffer is a real file buffer (not terminal, special buffer, etc.)
      --- @param bufnr integer Buffer number to check
      --- @return boolean True if buffer is a real file buffer
      function M.is_real_buffer(bufnr)
        -- Validate buffer exists first
        if not vim.api.nvim_buf_is_valid(bufnr) then
          return false
        end

        -- Safely get buffer options with error handling
        local ok, buftype = pcall(vim.api.nvim_get_option_value, 'buftype', { buf = bufnr })
        if not ok then
          return false
        end

        local ok2, filetype = pcall(vim.api.nvim_get_option_value, 'filetype', { buf = bufnr })
        if not ok2 then
          return false
        end

        -- Exclude terminal, toggleterm, quickfix, help, and other special buffers
        if buftype == 'terminal' or filetype == 'toggleterm' or filetype == 'terminal' then
          return false
        end
        if buftype ~= '' and buftype ~= 'acwrite' then
          return false
        end

        -- Exclude unnamed buffers
        local name = vim.api.nvim_buf_get_name(bufnr)
        if name == '' then
          return false
        end

        return true
      end

      --- Add buffer to current tab if not already present
      --- @param bufnr? integer Buffer number to add (defaults to current buffer)
      --- @param tabpage? integer Tabpage number (defaults to current tab)
      function M.add_buffer_to_tab(bufnr, tabpage)
        tabpage = tabpage or vim.api.nvim_get_current_tabpage()
        bufnr = bufnr or vim.api.nvim_get_current_buf()

        M.init_tab(tabpage)

        if not M.is_real_buffer(bufnr) then
          return
        end

        local tab_data = M.tab_buffers[tabpage]

        -- Check if buffer is already in this tab
        for i, buf in ipairs(tab_data.buffers) do
          if buf == bufnr then
            tab_data.active_index = i
            return
          end
        end

        -- Add new buffer to tab
        table.insert(tab_data.buffers, bufnr)
        tab_data.active_index = #tab_data.buffers
      end

      --- Get current tab's buffer list (automatically filters invalid buffers)
      --- @param tabpage? integer Tabpage number (defaults to current tab)
      --- @return integer[] List of valid buffer numbers in the tab
      function M.get_tab_buffers(tabpage)
        tabpage = tabpage or vim.api.nvim_get_current_tabpage()
        M.init_tab(tabpage)

        local tab_data = M.tab_buffers[tabpage]
        local valid_buffers = {}

        -- Filter out invalid/deleted buffers
        for _, buf in ipairs(tab_data.buffers) do
          if vim.api.nvim_buf_is_valid(buf) then
            table.insert(valid_buffers, buf)
          end
        end

        -- Update the buffer list with only valid buffers
        tab_data.buffers = valid_buffers
        if tab_data.active_index > #valid_buffers then
          tab_data.active_index = math.max(MIN_BUFFER_INDEX, #valid_buffers)
        end

        return valid_buffers
      end

      --- Switch to next buffer in current tab (cycles to first if at end)
      function M.next_buffer()
        local tabpage = vim.api.nvim_get_current_tabpage()
        local tab_buffers = M.get_tab_buffers(tabpage)

        if #tab_buffers <= 1 then
          return
        end

        local tab_data = M.tab_buffers[tabpage]
        tab_data.active_index = tab_data.active_index >= #tab_buffers and MIN_BUFFER_INDEX or tab_data.active_index + 1
        vim.api.nvim_set_current_buf(tab_buffers[tab_data.active_index])
      end

      --- Switch to previous buffer in current tab (cycles to last if at start)
      function M.prev_buffer()
        local tabpage = vim.api.nvim_get_current_tabpage()
        local tab_buffers = M.get_tab_buffers(tabpage)

        if #tab_buffers <= 1 then
          return
        end

        local tab_data = M.tab_buffers[tabpage]
        tab_data.active_index = tab_data.active_index <= MIN_BUFFER_INDEX and #tab_buffers or tab_data.active_index - 1
        vim.api.nvim_set_current_buf(tab_buffers[tab_data.active_index])
      end

      --- Switch to buffer by index in current tab
      --- @param index integer Buffer index (1-based) within current tab's buffer list
      function M.goto_buffer(index)
        local tabpage = vim.api.nvim_get_current_tabpage()
        local tab_buffers = M.get_tab_buffers(tabpage)

        if index >= MIN_BUFFER_INDEX and index <= #tab_buffers then
          local tab_data = M.tab_buffers[tabpage]
          tab_data.active_index = index
          vim.api.nvim_set_current_buf(tab_buffers[index])
        end
      end

      --- Remove buffer from tab's buffer list
      --- @param bufnr? integer Buffer number to remove (defaults to current buffer)
      --- @param tabpage? integer Tabpage number (defaults to current tab)
      function M.remove_buffer_from_tab(bufnr, tabpage)
        tabpage = tabpage or vim.api.nvim_get_current_tabpage()
        bufnr = bufnr or vim.api.nvim_get_current_buf()

        if not M.tab_buffers[tabpage] then
          return
        end

        local tab_data = M.tab_buffers[tabpage]
        for i, buf in ipairs(tab_data.buffers) do
          if buf == bufnr then
            table.remove(tab_data.buffers, i)
            if tab_data.active_index > i then
              tab_data.active_index = tab_data.active_index - 1
            elseif tab_data.active_index > #tab_data.buffers then
              tab_data.active_index = math.max(MIN_BUFFER_INDEX, #tab_data.buffers)
            end
            break
          end
        end
      end

      --- Close buffer in tab-aware way (switches to next buffer first, creates new if last)
      --- @param bufnr? integer Buffer number to close (defaults to current buffer)
      function M.close_buffer(bufnr)
        bufnr = bufnr or vim.api.nvim_get_current_buf()
        local tabpage = vim.api.nvim_get_current_tabpage()
        local tab_buffers = M.get_tab_buffers(tabpage)

        -- If this is the only buffer in the tab, create a new empty buffer
        if #tab_buffers <= 1 then
          vim.cmd 'enew'
          M.add_buffer_to_tab(vim.api.nvim_get_current_buf(), tabpage)
        else
          -- Switch to next buffer before closing
          M.next_buffer()
        end

        -- Remove from tab tracking and close
        M.remove_buffer_from_tab(bufnr, tabpage)
        vim.api.nvim_buf_delete(bufnr, { force = false })
      end

      --- Setup autocmds for automatic buffer tracking across tab lifecycle
      local function setup_autocmds()
        local augroup = vim.api.nvim_create_augroup('TabScopedBuffers', { clear = true })

        -- Track when buffers are entered/opened
        vim.api.nvim_create_autocmd({ 'BufEnter', 'BufNew' }, {
          group = augroup,
          callback = function(ev)
            M.add_buffer_to_tab(ev.buf)
          end,
        })

        -- Clean up when buffers are deleted
        vim.api.nvim_create_autocmd('BufDelete', {
          group = augroup,
          callback = function(ev)
            -- Remove buffer from all tabs
            for tabpage, _ in pairs(M.tab_buffers) do
              M.remove_buffer_from_tab(ev.buf, tabpage)
            end
          end,
        })

        -- Clean up when tabs are closed
        vim.api.nvim_create_autocmd('TabClosed', {
          group = augroup,
          callback = function(ev)
            local tabpage = tonumber(ev.match)
            if tabpage and M.tab_buffers[tabpage] then
              M.tab_buffers[tabpage] = nil
            end
          end,
        })
      end

      -- Initialize and make available globally
      _G.TabScopedBuffers = M
      setup_autocmds()

      -- Initialize current tab
      M.add_buffer_to_tab()

      --- @class BufferlineFilterCache
      --- @field tab integer|nil Last processed tabpage number
      --- @field buffers_set table<integer, boolean> Set of buffer numbers in current tab
      --- @field version integer Cache version to detect stale data

      --- Cache for bufferline custom_filter to avoid repeated get_tab_buffers calls
      local filter_cache = {
        tab = nil,
        buffers_set = {},
        version = 0,
      }

      --- Update cache version when buffers change
      local original_add = M.add_buffer_to_tab
      M.add_buffer_to_tab = function(...)
        original_add(...)
        filter_cache.version = filter_cache.version + 1
      end

      local original_remove = M.remove_buffer_from_tab
      M.remove_buffer_from_tab = function(...)
        original_remove(...)
        filter_cache.version = filter_cache.version + 1
      end

      -- Simple bufferline setup with optimized tab-scoped filtering
      bufferline.setup {
        options = {
          numbers = function(opts)
            -- Show buffer index within current tab
            local tab_buffers = M.get_tab_buffers()
            for i, buf in ipairs(tab_buffers) do
              if buf == opts.id then
                return string.format('%d', i)
              end
            end
            return ''
          end,
          custom_filter = function(buf_number, buf_numbers)
            -- Cached implementation: only refresh when tab or buffers change
            local current_tab = vim.api.nvim_get_current_tabpage()
            if filter_cache.tab ~= current_tab or filter_cache.version ~= M.version then
              filter_cache.tab = current_tab
              local tab_buffers = M.get_tab_buffers()
              filter_cache.buffers_set = {}
              for _, buf in ipairs(tab_buffers) do
                filter_cache.buffers_set[buf] = true
              end
              M.version = filter_cache.version
            end
            return filter_cache.buffers_set[buf_number] or false
          end,
        },
      }
    end,
  },
}
