local dap_ok, dap = pcall(require, "dap")
local dap_vscode_js_ok = pcall(require, "dap-vscode-js")

if not dap_ok then
  return
end

lvim.builtin.which_key.mappings['d']['l'] = {
  "<cmd>lua require'dap'.run_last()<CR>", "Run last"
}

local mason_path = vim.fn.glob(vim.fn.stdpath "data" .. "/mason/")

if dap_vscode_js_ok then
  require("dap-vscode-js").setup {
    debugger_path = mason_path .. "packages/js-debug-adapter",                                   -- Path to vscode-js-debug installation.
    adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }, -- which adapters to register in nvim-dap
  }

  local function get_test_at_cursor()
    local grep = nil
    local node = vim.treesitter.get_node()
    local maxAppends = 4

    while node do
      if node:type() == "call_expression" then
        local fn = vim.treesitter.get_node_text(node:child(0), 0)
        if fn == "it" or fn == "describe" then
          local arguments = node:child(1)
          local spec = vim.treesitter.get_node_text(arguments:child(1):child(1), 0)
          if grep == nil then
            grep = spec
          else
            grep = spec .. " " .. grep
          end
          maxAppends = maxAppends - 1
          if maxAppends == 0 then
            break
          end
        end
      end
      node = node:parent()
    end
    return string.gsub(grep, "([()])", "\\%1");
  end

  local function resolve_nx_test_runner()
    if vim.fn.findfile("vite.config.ts", ".:") ~= nil then
      return "vite"
    end

    if vim.fn.findfile("jest.config.ts", ".:") ~= nil then
      return "jest"
    end

    return nil
  end

  local function resolve_nx_test_config(runner)
    return vim.fn.findfile(runner .. ".config.ts", ".;")
  end

  local function resolve_nx_test_args(all)
    return function()
      local runner = resolve_nx_test_runner()
      local config = resolve_nx_test_config(runner)
      local args = { "${fileBasenameNoExtension}", '--config', config }

      if runner == "jest" then
        table.insert(args, "--runInBand")
      end

      if runner == "vite" then
        table.insert(args, "--run")
      end

      if all == false then
        local test = get_test_at_cursor()

        if test ~= nil then
          table.insert(args, "-t")
          table.insert(args, test)
        end
      end
      return args
    end
  end

  local function resolve_nx_test_program()
    return function()
      local runner = resolve_nx_test_runner()

      if runner == 'vite' then
        return vim.fn.getcwd() .. "/node_modules/.bin/vitest"
      end

      if runner == 'jest' then
        return vim.fn.getcwd() .. "/node_modules/.bin/jest"
      end
    end
  end

  local function resolve_mocha_config()
    return vim.fn.findfile(".mocharc.js", ".;")
  end

  local function resolve_mocha_args(extra)
    return function()
      local args = { "--config", resolve_mocha_config(), "--timeouts", "9999999" }
      local test = get_test_at_cursor()

      if test ~= nil then
        table.insert(args, "--grep")
        table.insert(args, "\"" .. test .. "\"")
      end
      if extra ~= nil then
        for value in extra do
          table.insert(args, value)
        end
      end
      print(vim.inspect(args))
      return args
    end
  end

  local function resolve_jest_args()
    local args = {
      "${workspaceFolder}/node_modules/.bin/jest",
      "${relativeFileDirname}/${fileBasenameNoExtension}",
      "--runInBand",
      "--config",
      vim.fn.findfile("jest.config.js", ".;"),
      "--testNamePattern",
      get_test_at_cursor(),
    }
    return args;
  end

  local function resolve_mocha_program()
    return vim.fn.getcwd() .. "/node_modules/.bin/_mocha"
  end

  local function ask_port()
    return vim.fn.input('Port: ')
  end

  for _, language in ipairs { "typescript", "javascript", "typescriptreact" } do
    require("dap").configurations[language] = {
      {
        type = "pwa-node",
        request = "launch",
        name = "Mocha: test",
        runtimeExecutable = resolve_mocha_program,
        runtimeArgs = resolve_mocha_args(),
        rootPath = "${workspaceFolder}",
        cwd = "${workspaceFolder}",
        console = "integratedTerminal",
        internalConsoleOptions = "neverOpen",
      },
      -- {
      --   type = "pwa-node",
      --   request = "launch",
      --   name = "Debug Mocha Current Tests (api2)",
      --   runtimeExecutable = resolve_mocha_program,
      --   runtimeArgs = function()
      --     local test_at_cursor = get_test_at_cursor()
      --     local args = {
      --       "--colors",
      --       "--max-old-space-size=8192",
      --       "--no-warnings",
      --       "--exit",
      --       "--timeout",
      --       "99999s",
      --       "--require",
      --       "./test/init-validators.js",
      --       "--require",
      --       "./test/init.js",
      --       "--grep",
      --       test_at_cursor
      --     }
      --     print(vim.inspect(args))
      --     return args;
      --   end,
      --   rootPath = "${workspaceFolder}",
      --   cwd = "${workspaceFolder}",
      --   console = "integratedTerminal",
      --   internalConsoleOptions = "openOnSessionStart",
      --   skipFiles = { "<node_internals>/**" },
      -- },
      {
        type = "pwa-node",
        request = "launch",
        name = "Jest: test",
        runtimeExecutable = "node",
        runtimeArgs = resolve_jest_args,
        rootPath = "${workspaceFolder}",
        cwd = "${workspaceFolder}",
        console = "integratedTerminal",
        internalConsoleOptions = "neverOpen",
      },
      {
        type = "pwa-node",
        request = "launch",
        name = "NX: test all",
        runtimeExecutable = resolve_nx_test_program(),
        runtimeArgs = resolve_nx_test_args(true),
        rootPath = "${workspaceFolder}",
        cwd = "${workspaceFolder}",
        console = "integratedTerminal",
        internalConsoleOptions = "neverOpen",
      },
      {
        type = "pwa-node",
        request = "launch",
        name = "NX: test",
        runtimeExecutable = resolve_nx_test_program(),
        runtimeArgs = resolve_nx_test_args(false),
        rootPath = "${workspaceFolder}",
        cwd = "${workspaceFolder}",
        console = "integratedTerminal",
        internalConsoleOptions = "neverOpen",
      },
      {
        type = "pwa-node",
        request = "attach",
        name = "Node debug",
        port = ask_port,
        cwd = "${workspaceFolder}",
        autoAttachChildProcesses = true,
      },
      -- {
      --   type = "pwa-node",
      --   request = "attach",
      --   name = "Node.js Attach (9229)",
      --   processId = require 'dap.utils'.pick_process,
      --   port = 9229,
      --   cwd = "${workspaceFolder}",
      -- },
      -- {
      --   type = "pwa-node",
      --   request = "attach",
      --   name = "Node.js Attach (5860)",
      --   processId = require 'dap.utils'.pick_process,
      --   port = 5860,
      --   cwd = "${workspaceFolder}",
      -- },
      -- {
      --   type = "pwa-node",
      --   request = "attach",
      --   name = "Node.js Attach (5858)",
      --   processId = require 'dap.utils'.pick_process,
      --   port = 5858,
      --   cwd = "${workspaceFolder}",
      -- },
      -- {
      --   type = "pwa-node",
      --   request = "attach",
      --   name = "Node.js Attach (5961)",
      --   processId = require 'dap.utils'.pick_process,
      --   port = 5961,
      --   cwd = "${workspaceFolder}",
      -- },
    }
  end
end

function resolve_main_class()
  local currentBuffer = vim.fn.fnamemodify(vim.fn.expand("%"), ":r")
  local packageAnchor = "main/java/"
  local packageStart = vim.fn.strridx(currentBuffer, packageAnchor) + vim.fn.strlen(packageAnchor)
  local packagePath = vim.fn.strpart(currentBuffer, packageStart)

  return string.gsub(packagePath, "/", ".")
end

local jdtls_ok, jdtls = pcall(require, "jdtls")

if jdtls_ok and jdtls.dap_ok then
  jdtls.dap.setup_dap_main_class_configs();
end

dap.configurations.java = {
  {
    type = "java",
    request = "attach",
    name = "Java Attach",
    hostName = "localhost",
    port = 5005,
  },
  {
    type = "java",
    request = "launch",
    name = "Java: Dropwizard Server",
    mainClass = resolve_main_class,
    args = "server"
  },
  {
    type = "java",
    request = "launch",
    name = "Java: Spring",
    mainClass = resolve_main_class,
  },
}

-- require('dap.ext.vscode').load_launchjs(vim.fn.getcwd() .. "/.vscode/launch.json", {
--   node2 = { 'javascript', 'typescript', 'typescriptreact' }
-- })

-- Go --
local dapgo_ok, dapgo = pcall(require, "dap-go")

if dapgo_ok then
  dapgo.setup()
end
