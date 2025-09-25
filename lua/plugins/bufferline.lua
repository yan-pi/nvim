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

      -- Proper buffer-to-tab tracking using autocmds and persistent state

      local M = {}
      M.tab_buffers = {} -- Maps tab_id -> {buffers = {buf1, buf2, ...}, active_index = 1}

      -- Initialize tab buffer tracking
      function M.init_tab(tabpage)
        tabpage = tabpage or vim.api.nvim_get_current_tabpage()
        if not M.tab_buffers[tabpage] then
          M.tab_buffers[tabpage] = {
            buffers = {},
            active_index = 1,
          }
        end
      end

      -- Add buffer to current tab if not already present
      function M.add_buffer_to_tab(bufnr, tabpage)
        tabpage = tabpage or vim.api.nvim_get_current_tabpage()
        bufnr = bufnr or vim.api.nvim_get_current_buf()

        M.init_tab(tabpage)

        -- Only add real files, not special buffers
        local buftype = vim.api.nvim_get_option_value('buftype', { buf = bufnr })
        if buftype ~= '' and buftype ~= 'acwrite' then
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

      -- Get current tab's buffer list
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
          tab_data.active_index = math.max(1, #valid_buffers)
        end

        return valid_buffers
      end

      -- Switch to next buffer in current tab
      function M.next_buffer()
        local tabpage = vim.api.nvim_get_current_tabpage()
        local tab_buffers = M.get_tab_buffers(tabpage)

        if #tab_buffers <= 1 then
          return
        end

        local tab_data = M.tab_buffers[tabpage]
        tab_data.active_index = tab_data.active_index >= #tab_buffers and 1 or tab_data.active_index + 1
        vim.api.nvim_set_current_buf(tab_buffers[tab_data.active_index])
      end

      -- Switch to previous buffer in current tab
      function M.prev_buffer()
        local tabpage = vim.api.nvim_get_current_tabpage()
        local tab_buffers = M.get_tab_buffers(tabpage)

        if #tab_buffers <= 1 then
          return
        end

        local tab_data = M.tab_buffers[tabpage]
        tab_data.active_index = tab_data.active_index <= 1 and #tab_buffers or tab_data.active_index - 1
        vim.api.nvim_set_current_buf(tab_buffers[tab_data.active_index])
      end

      -- Switch to buffer by index in current tab
      function M.goto_buffer(index)
        local tabpage = vim.api.nvim_get_current_tabpage()
        local tab_buffers = M.get_tab_buffers(tabpage)

        if index >= 1 and index <= #tab_buffers then
          local tab_data = M.tab_buffers[tabpage]
          tab_data.active_index = index
          vim.api.nvim_set_current_buf(tab_buffers[index])
        end
      end

      -- Remove buffer from tab
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
              tab_data.active_index = math.max(1, #tab_data.buffers)
            end
            break
          end
        end
      end

      -- Close buffer in tab-aware way
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

      -- Setup autocmds for buffer tracking
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

      -- Simple bufferline setup with only tab-scoped filtering
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
            -- Only show buffers that belong to the current tab
            local tab_buffers = M.get_tab_buffers()
            for _, tab_buf in ipairs(tab_buffers) do
              if tab_buf == buf_number then
                return true
              end
            end
            return false
          end,
        },
      }
    end,
  },
}
