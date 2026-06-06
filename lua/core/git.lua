-- Git utilities: open modified/added/untracked files via picker or all-at-once

local M = {}

-- Parse git status --porcelain and return relevant items.
-- Includes: M (modified), A (added), ?? (untracked), R (renamed), D (deleted)
local function git_status_items()
  local cwd = vim.fn.getcwd()
  local result = vim.system({ 'git', 'status', '--porcelain' }, { cwd = cwd, text = true }):wait()

  if result.code ~= 0 then
    vim.notify('Not a git repository or git error', vim.log.levels.WARN)
    return {}
  end

  local items = {}
  for line in result.stdout:gmatch('[^\r\n]+') do
    if #line >= 3 then
      local status = line:sub(1, 2)
      local file = line:sub(4)

      local index_status = status:sub(1, 1)
      local worktree_status = status:sub(2, 2)

      local is_relevant = index_status == 'M'
        or index_status == 'A'
        or index_status == 'R'
        or index_status == 'D'
        or worktree_status == 'M'
        or worktree_status == 'A'
        or worktree_status == 'D'
        or status == '??'

      if is_relevant then
        table.insert(items, {
          text = status .. '  ' .. file,
          file = file,
          status = status,
        })
      end
    end
  end

  return items
end

-- Open picker with git modified/added/untracked files.
function M.open_modified_picker()
  local items = git_status_items()
  if #items == 0 then
    vim.notify('No modified, added, or untracked files', vim.log.levels.INFO)
    return
  end

  Snacks.picker.pick {
    source = 'git.open_modified',
    title = 'Git Modified / Added / Untracked',
    items = items,
    format = function(item)
      local hl = 'Normal'
      local s = item.status

      if s == '??' then
        hl = 'DiagnosticInfo'
      elseif s:find('M') then
        hl = 'DiagnosticWarn'
      elseif s:find('A') then
        hl = 'DiagnosticOk'
      elseif s:find('D') then
        hl = 'DiagnosticError'
      elseif s:find('R') then
        hl = 'DiagnosticHint'
      end

      return {
        { s .. '  ', hl },
        { item.file },
      }
    end,
    confirm = function(_, item)
      if item and item.file then
        vim.cmd('edit ' .. vim.fn.fnameescape(item.file))
      end
    end,
  }
end

-- Open ALL modified/added/untracked files in buffers at once.
function M.open_all_modified()
  local items = git_status_items()
  if #items == 0 then
    vim.notify('No modified, added, or untracked files', vim.log.levels.INFO)
    return
  end

  local count = 0
  for _, item in ipairs(items) do
    vim.cmd('badd ' .. vim.fn.fnameescape(item.file))
    count = count + 1
  end

  vim.notify('Added ' .. count .. ' file(s) to buffer list', vim.log.levels.INFO)
end

-- Keymaps
vim.keymap.set('n', '<leader>go', M.open_modified_picker, { desc = '[G]it [O]pen modified (picker)' })
vim.keymap.set('n', '<leader>gO', M.open_all_modified, { desc = '[G]it [O]pen all modified' })

return M
