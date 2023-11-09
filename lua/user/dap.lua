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


  local function resolve_nx_jest_config()
    return vim.fn.findfile("jest.config.ts", ".;")
  end

  local function resolve_nx_jest_args(forTest)
    local args = { "${fileBasenameNoExtension}", '--config', resolve_nx_jest_config(), "--runInBand" }
    if forTest == true then
      local test = get_test_at_cursor()

      if test ~= nil then
        table.insert(args, "-t")
        table.insert(args, test)
      end
    end
    return args
  end

  local function resolve_nx_jest_args_for_test()
    return resolve_nx_jest_args(true)
  end

  local function resolve_nx_jest_args_for_file()
    return resolve_nx_jest_args(false)
  end

  local function resolve_jest_program()
    return vim.fn.getcwd() .. "/node_modules/.bin/jest"
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
    return vim.fn.input('Port:')
  end
  -- {
  --   "args": [
  --     "--colors",
  --     "--max-old-space-size=8192",
  --     "--no-warnings",
  --     "--exit",
  --     "--timeout",
  --     "99999s",
  --     "--require",
  --     "./test/init-validators.js",
  --     "--require",
  --     "./test/init.js",
  --     "${file}"
  --   ],
  --   "internalConsoleOptions": "openOnSessionStart",
  --   "name": "Run tests in current file",
  --   "program": "${workspaceFolder}/node_modules/.bin/_mocha",
  --   "request": "launch",
  --   "skipFiles": [
  --     "<node_internals>/**"
  --   ],
  --   "type": "node"
  -- },


  for _, language in ipairs { "typescript", "javascript", "typescriptreact" } do
    require("dap").configurations[language] = {
      {
        type = "pwa-node",
        request = "launch",
        name = "Debug Mocha Current Tests",
        runtimeExecutable = resolve_mocha_program,
        runtimeArgs = resolve_mocha_args(),
        rootPath = "${workspaceFolder}",
        cwd = "${workspaceFolder}",
        console = "integratedTerminal",
        internalConsoleOptions = "neverOpen",
      },
      {
        type = "pwa-node",
        request = "launch",
        name = "Debug Mocha Current Tests (api2)",
        runtimeExecutable = resolve_mocha_program,
        runtimeArgs = function()
          local test_at_cursor = get_test_at_cursor()
          local args = {
            "--colors",
            "--max-old-space-size=8192",
            "--no-warnings",
            "--exit",
            "--timeout",
            "99999s",
            "--require",
            "./test/init-validators.js",
            "--require",
            "./test/init.js",
            "--grep",
            test_at_cursor
          }
          print(vim.inspect(args))
          return args;
        end,
        rootPath = "${workspaceFolder}",
        cwd = "${workspaceFolder}",
        console = "integratedTerminal",
        internalConsoleOptions = "openOnSessionStart",
        skipFiles = { "<node_internals>/**" },
      },
      {
        type = "pwa-node",
        request = "launch",
        name = "Debug Jest Current Tests",
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
        name = "NX: Run all tests in file",
        runtimeExecutable = resolve_jest_program,
        runtimeArgs = resolve_nx_jest_args_for_file,
        rootPath = "${workspaceFolder}",
        cwd = "${workspaceFolder}",
        console = "integratedTerminal",
        internalConsoleOptions = "neverOpen",
      },
      {
        type = "pwa-node",
        request = "launch",
        name = "NX: Run this test",
        runtimeExecutable = resolve_jest_program,
        runtimeArgs = resolve_nx_jest_args_for_test,
        rootPath = "${workspaceFolder}",
        cwd = "${workspaceFolder}",
        console = "integratedTerminal",
        internalConsoleOptions = "neverOpen",
      },
      {
        type = "pwa-node",
        request = "attach",
        name = "Node.js Attach (9229)",
        processId = require 'dap.utils'.pick_process,
        port = 9229,
        cwd = "${workspaceFolder}",
      },
      {
        type = "pwa-node",
        request = "attach",
        name = "Node.js Attach (5860)",
        processId = require 'dap.utils'.pick_process,
        port = 5860,
        cwd = "${workspaceFolder}",
      },
      {
        type = "pwa-node",
        request = "attach",
        name = "Node.js Attach (5858)",
        processId = require 'dap.utils'.pick_process,
        port = 5858,
        cwd = "${workspaceFolder}",
      },
      {
        type = "pwa-node",
        request = "attach",
        name = "Node.js Attach (5961)",
        processId = require 'dap.utils'.pick_process,
        port = 5961,
        cwd = "${workspaceFolder}",
      },
      {
        type = "pwa-node",
        request = "attach",
        name = "Node debug",
        processId = require 'dap.utils'.pick_process,
        port = ask_port,
        cwd = "${workspaceFolder}",
      },
    }
  end
end

-- if mason_ok and mason.is_installed("node-debug2-adapter") then
--   dap.adapters.node2 = {
--     type = 'executable',
--     command = 'node',
--     args = { vim.fn.stdpath("data") .. '/mason/packages/node-debug2-adapter/out/src/nodeDebug.js' },
--   }

--   local function resolve_nx_jest_config()
--     local currentBufferPath = vim.fn.fnamemodify(vim.fn.expand("%"), ":h")
--     local sourcePathPos = vim.fn.stridx(currentBufferPath, "/src")
--     if sourcePathPos < 0 then
--       sourcePathPos = vim.fn.stridx(currentBufferPath, "/tests")
--     end
--     local projectRoot = vim.fn.strpart(currentBufferPath, 0, sourcePathPos)

--     return projectRoot .. "/jest.config.ts"
--   end

--   local function resolve_nx_jest_args()
--     return { "${fileBasenameNoExtension}", '--config', resolve_nx_jest_config() }
--   end

--   local function resolve_jest_program()
--     return vim.fn.getcwd() .. "/node_modules/.bin/jest"
--   end

--   dap.configurations.typescript = {
--     {
--       type = "node2",
--       name = "NX: Jest current file",
--       request = "launch",
--       program = resolve_jest_program,
--       args = resolve_nx_jest_args,
--       cwd = vim.fn.getcwd,
--       console = 'integratedTerminal'
--     }
--   }

--   dap.configurations.typescriptreact = {
--     {
--       type = "node2",
--       name = "NX: Jest current file",
--       request = "launch",
--       program = resolve_jest_program,
--       args = resolve_nx_jest_args,
--       cwd = vim.fn.getcwd,
--       console = 'integratedTerminal'
--     }
--   }
-- end

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
