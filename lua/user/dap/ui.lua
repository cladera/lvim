local dap_ok, dap = pcall(require, "dap")
local dapui_ok, dapui = pcall(require, "dapui")

if not dap_ok then
  print('dap not available')
  return
end

if not dapui_ok then
  print('dapui not available')
  return
end

dapui.setup({
  icons = { expanded = "▾", collapsed = "▸" },
  mappings = {
    -- Use a table to apply multiple mappings
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
    toggle = "t",
  },
  -- Expand lines larger than the window
  -- Requires >= 0.7
  expand_lines = vim.fn.has("nvim-0.8"),
  layouts = {
    {
      elements = {
        'scopes',
        'breakpoints',
        'stacks',
        'watches'
      },
      size = 40,
      position = 'left'
    },
    {
      elements = {
        'repl',
        'console'
      },
      size = 10,
      position = 'bottom'

    }

  },
  floating = {
    max_height = nil, -- These can be integers or a float between 0 and 1.
    max_width = nil, -- Floats will be treated as percentage of your screen.
    border = "single", -- Border style. Can be "single", "double" or "rounded"
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
  render = {
    max_type_length = nil, -- Can be integer or nil.
  }
})

-- dap listeners
dap.listeners.after.event_initialized['dapui-config'] = function()
  dapui.open()
end

dap.listeners.after.event_terminated['dapui-config'] = function()
  dapui.close()
end

dap.listeners.after.event_exited['dapui-config'] = function()
  dapui.close()
end
