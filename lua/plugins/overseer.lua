-- lua/plugins/overseer.lua
-- Task runner for build commands, tests, and custom tasks

return {
  'stevearc/overseer.nvim',
  cmd = {
    'OverseerRun',
    'OverseerToggle',
    'OverseerOpen',
    'OverseerClose',
    'OverseerTaskAction',
    'OverseerQuickAction',
    'OverseerBuild',
    'OverseerInfo',
  },
  keys = {
    { '<leader>Or', '<cmd>OverseerRun<cr>', desc = '[O]verseer [R]un task' },
    { '<leader>Ot', '<cmd>OverseerToggle<cr>', desc = '[O]verseer [T]oggle' },
    { '<leader>Oo', '<cmd>OverseerOpen<cr>', desc = '[O]verseer [O]pen' },
    { '<leader>Oc', '<cmd>OverseerClose<cr>', desc = '[O]verseer [C]lose' },
    { '<leader>Oa', '<cmd>OverseerTaskAction<cr>', desc = '[O]verseer Task [A]ction' },
    { '<leader>Oq', '<cmd>OverseerQuickAction<cr>', desc = '[O]verseer [Q]uick action' },
    { '<leader>Ob', '<cmd>OverseerBuild<cr>', desc = '[O]verseer [B]uild task' },
    { '<leader>Oi', '<cmd>OverseerInfo<cr>', desc = '[O]verseer [I]nfo' },
  },
  opts = {
    -- Task list configuration
    task_list = {
      direction = 'bottom',
      min_height = 15,
      max_height = 25,
      default_detail = 1,
      bindings = {
        ['?'] = 'ShowHelp',
        ['g?'] = 'ShowHelp',
        ['<CR>'] = 'RunAction',
        ['<C-e>'] = 'Edit',
        ['o'] = 'Open',
        ['<C-v>'] = 'OpenVsplit',
        ['<C-s>'] = 'OpenSplit',
        ['<C-f>'] = 'OpenFloat',
        ['<C-q>'] = 'OpenQuickFix',
        ['p'] = 'TogglePreview',
        ['<C-l>'] = 'IncreaseDetail',
        ['<C-h>'] = 'DecreaseDetail',
        ['L'] = 'IncreaseAllDetail',
        ['H'] = 'DecreaseAllDetail',
        ['['] = 'DecreaseWidth',
        [']'] = 'IncreaseWidth',
        ['{'] = 'PrevTask',
        ['}'] = 'NextTask',
        ['<C-k>'] = 'ScrollOutputUp',
        ['<C-j>'] = 'ScrollOutputDown',
        ['q'] = 'Close',
      },
    },
    -- Form window for building tasks
    form = {
      border = 'rounded',
      win_opts = {
        winblend = 0,
      },
    },
    -- Task launcher window
    task_launcher = {
      bindings = {
        i = {
          ['<C-s>'] = 'Submit',
          ['<C-c>'] = 'Cancel',
        },
        n = {
          ['<CR>'] = 'Submit',
          ['<C-s>'] = 'Submit',
          ['q'] = 'Cancel',
          ['?'] = 'ShowHelp',
        },
      },
    },
    -- Task editor window
    task_editor = {
      bindings = {
        i = {
          ['<CR>'] = 'NextOrSubmit',
          ['<C-s>'] = 'Submit',
          ['<Tab>'] = 'Next',
          ['<S-Tab>'] = 'Prev',
          ['<C-c>'] = 'Cancel',
        },
        n = {
          ['<CR>'] = 'NextOrSubmit',
          ['<C-s>'] = 'Submit',
          ['<Tab>'] = 'Next',
          ['<S-Tab>'] = 'Prev',
          ['q'] = 'Cancel',
          ['?'] = 'ShowHelp',
        },
      },
    },
    -- Confirmation window
    confirm = {
      border = 'rounded',
      win_opts = {
        winblend = 0,
      },
    },
    -- Component settings
    component_aliases = {
      default = {
        { 'display_duration', detail_level = 2 },
        'on_output_summarize',
        'on_exit_set_status',
        'on_complete_notify',
        'on_complete_dispose',
      },
    },
    -- Default template options
    dap = false,
    -- Strategy configuration
    strategy = {
      'toggleterm',
      direction = 'horizontal',
      open_on_start = true,
      quit_on_exit = 'success',
    },
    -- Automatically discover tasks from build tools
    templates = { 'builtin' },
    -- Log level (trace, debug, info, warn, error)
    log = {
      {
        type = 'echo',
        level = vim.log.levels.WARN,
      },
    },
  },
  config = function(_, opts)
    local overseer = require 'overseer'
    overseer.setup(opts)

    -- Auto-discover tasks for common build systems
    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'rust', 'python', 'javascript', 'typescript', 'go', 'c', 'cpp' },
      callback = function()
        -- Automatically load project-specific tasks
        overseer.load_task_bundle(vim.fn.getcwd(), { ignore_missing = true })
      end,
      group = vim.api.nvim_create_augroup('OverseerAutoLoad', { clear = true }),
    })

    -- Integration with telescope (if available)
    local has_telescope, telescope = pcall(require, 'telescope')
    if has_telescope then
      telescope.load_extension 'overseer'
      -- Add telescope keybind for task selection
      vim.keymap.set('n', '<leader>Of', '<cmd>Telescope overseer run<cr>', { desc = '[O]verseer [F]ind task (Telescope)' })
    end
  end,
}
