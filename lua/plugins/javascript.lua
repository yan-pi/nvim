-- JavaScript/TypeScript language support
-- Provides Node.js debugging via vscode-js-debug adapter
-- LSP configuration (ts_ls, eslint) is handled in lsp.lua
-- Formatting is handled in formatting.lua with project-aware detection

return {
  -- Node.js debugging with vscode-js-debug
  {
    'mfussenegger/nvim-dap',
    ft = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
    config = function()
      local dap = require 'dap'

      -- Only configure if js-debug-adapter is installed
      local mason_registry = require 'mason-registry'
      if not mason_registry.is_installed 'js-debug-adapter' then
        vim.notify('js-debug-adapter not installed. Run :MasonInstall js-debug-adapter', vim.log.levels.WARN)
        return
      end

      -- Get Mason installation path and construct js-debug-adapter path
      -- Mason stores packages in: ~/.local/share/nvim/mason/packages/
      local mason_path = vim.fn.stdpath 'data' .. '/mason/packages'
      local js_debug_path = mason_path .. '/js-debug-adapter/js-debug/src/dapDebugServer.js'

      -- Configure pwa-node adapter (Node.js debugging)
      dap.adapters['pwa-node'] = {
        type = 'server',
        host = 'localhost',
        port = '${port}',
        executable = {
          command = 'node',
          args = { js_debug_path, '${port}' },
        },
      }

      -- Debug configurations for JavaScript
      dap.configurations.javascript = {
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Launch Current File (Node)',
          program = '${file}',
          cwd = '${workspaceFolder}',
          sourceMaps = true,
          protocol = 'inspector',
          console = 'integratedTerminal',
        },
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Launch npm script',
          runtimeExecutable = 'npm',
          runtimeArgs = function()
            local script = vim.fn.input 'npm script: '
            return { 'run', script }
          end,
          cwd = '${workspaceFolder}',
          sourceMaps = true,
          protocol = 'inspector',
          console = 'integratedTerminal',
        },
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Debug Jest Tests',
          runtimeExecutable = 'node',
          runtimeArgs = {
            './node_modules/.bin/jest',
            '--runInBand',
            '--no-coverage',
            '${file}',
          },
          rootPath = '${workspaceFolder}',
          cwd = '${workspaceFolder}',
          console = 'integratedTerminal',
          internalConsoleOptions = 'neverOpen',
          sourceMaps = true,
        },
        {
          type = 'pwa-node',
          request = 'attach',
          name = 'Attach to Process',
          processId = require('dap.utils').pick_process,
          cwd = '${workspaceFolder}',
          sourceMaps = true,
          protocol = 'inspector',
        },
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Debug with --inspect',
          program = '${file}',
          cwd = '${workspaceFolder}',
          runtimeArgs = { '--inspect' },
          sourceMaps = true,
          protocol = 'inspector',
          console = 'integratedTerminal',
        },
      }

      -- TypeScript uses same configurations
      dap.configurations.typescript = dap.configurations.javascript
      dap.configurations.javascriptreact = dap.configurations.javascript
      dap.configurations.typescriptreact = dap.configurations.javascript
    end,
  },
}
