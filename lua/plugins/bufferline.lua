return {
  {
    'akinsho/bufferline.nvim',
    config = function()
      local bufferline = require 'bufferline'
      local state = { tabs = {} }

      local function tabpage()
        return vim.api.nvim_get_current_tabpage()
      end

      local function valid_buffer(bufnr)
        return vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buftype == '' and vim.api.nvim_buf_get_name(bufnr) ~= ''
      end

      local function ensure_tab(tab)
        state.tabs[tab] = state.tabs[tab] or { buffers = {}, active = 1 }
        return state.tabs[tab]
      end

      local function prune(tab)
        local tab_state = ensure_tab(tab)
        local valid = {}
        for _, bufnr in ipairs(tab_state.buffers) do
          if valid_buffer(bufnr) then
            valid[#valid + 1] = bufnr
          end
        end
        tab_state.buffers = valid
        tab_state.active = math.min(tab_state.active, math.max(1, #valid))
        return tab_state
      end

      local function add(bufnr, tab)
        tab = tab or tabpage()
        if not valid_buffer(bufnr) then
          return
        end
        local tab_state = ensure_tab(tab)
        for index, existing in ipairs(tab_state.buffers) do
          if existing == bufnr then
            tab_state.active = index
            return
          end
        end
        tab_state.buffers[#tab_state.buffers + 1] = bufnr
        tab_state.active = #tab_state.buffers
      end

      local function buffers(tab)
        return prune(tab or tabpage()).buffers
      end

      local function select(index)
        local tab_state = prune(tabpage())
        if index >= 1 and index <= #tab_state.buffers then
          tab_state.active = index
          vim.api.nvim_set_current_buf(tab_state.buffers[index])
        end
      end

      local function move(delta)
        local tab_state = prune(tabpage())
        if #tab_state.buffers < 2 then
          return
        end
        tab_state.active = ((tab_state.active - 1 + delta) % #tab_state.buffers) + 1
        vim.api.nvim_set_current_buf(tab_state.buffers[tab_state.active])
      end

      local function remove(bufnr, tab)
        local tab_state = ensure_tab(tab or tabpage())
        for index, existing in ipairs(tab_state.buffers) do
          if existing == bufnr then
            table.remove(tab_state.buffers, index)
            tab_state.active = math.min(tab_state.active, math.max(1, #tab_state.buffers))
            return
          end
        end
      end

      local function close(bufnr)
        bufnr = bufnr or vim.api.nvim_get_current_buf()
        local current = buffers()
        if #current > 1 then
          move(1)
        else
          vim.cmd.enew()
          add(vim.api.nvim_get_current_buf())
        end
        remove(bufnr)
        vim.api.nvim_buf_delete(bufnr, { force = false })
      end

      _G.TabScopedBuffers = {
        get_tab_buffers = buffers,
        next_buffer = function()
          move(1)
        end,
        prev_buffer = function()
          move(-1)
        end,
        goto_buffer = select,
        close_buffer = close,
      }

      local group = vim.api.nvim_create_augroup('kali-minimal-buffers', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufNew' }, {
        group = group,
        callback = function(args)
          add(args.buf)
        end,
      })
      vim.api.nvim_create_autocmd('BufDelete', {
        group = group,
        callback = function(args)
          remove(args.buf)
        end,
      })
      vim.api.nvim_create_autocmd('TabClosed', {
        group = group,
        callback = function(args)
          state.tabs[tonumber(args.match)] = nil
        end,
      })

      add(vim.api.nvim_get_current_buf())
      bufferline.setup {
        options = {
          always_show_bufferline = true,
          numbers = function(opts)
            for index, bufnr in ipairs(buffers()) do
              if bufnr == opts.id then
                return tostring(index)
              end
            end
            return ''
          end,
          custom_filter = function(bufnr)
            for _, current in ipairs(buffers()) do
              if current == bufnr then
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
