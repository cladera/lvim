local dap_ok, dap = pcall(require, "dap")
local mason_ok, mason = pcall(require, "mason-registry")

if not dap_ok then
  return
end

if mason_ok and mason.is_installed("node-debug2-adapter") then
  dap.adapters.node2 = {
    type = 'executable',
    command = 'node',
    args = { vim.fn.stdpath("data") .. '/mason/packages/node-debug2-adapter/out/src/nodeDebug.js' },
  }

  local function resolve_nx_jest_config()
    local currentBufferPath = vim.fn.fnamemodify(vim.fn.expand("%"), ":h")
    local sourcePathPos = vim.fn.stridx(currentBufferPath, "/src")
    if sourcePathPos < 0 then
      sourcePathPos = vim.fn.stridx(currentBufferPath, "/tests")
    end
    local projectRoot = vim.fn.strpart(currentBufferPath, 0, sourcePathPos)

    return projectRoot .. "/jest.config.ts"
  end

  local function resolve_nx_jest_args()
    return { "${fileBasenameNoExtension}", '--config', resolve_nx_jest_config() }
  end

  local function resolve_jest_program()
    return vim.fn.getcwd() .. "/node_modules/.bin/jest"
  end

  dap.configurations.typescript = {
    {
      type = "node2",
      name = "NX: Jest current file",
      request = "launch",
      program = resolve_jest_program,
      args = resolve_nx_jest_args,
      cwd = vim.fn.getcwd,
      console = 'integratedTerminal'
    }
  }
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
    type = "java";
    request = "attach";
    name = "Java Attach";
    hostName = "localhost";
    port = 5005;
  },
  {
    type = "java";
    request = "launch";
    name = "Java: Dropwizard Server";
    mainClass = resolve_main_class;
    args = "server"
  },
  {
    type = "java";
    request = "launch";
    name = "Java: Spring";
    mainClass = resolve_main_class;
  },
}

require('dap.ext.vscode').load_launchjs(vim.fn.getcwd() .. "/.vscode/launch.json", {
  node2 = { 'javascript', 'typescript' }
})
