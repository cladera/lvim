local ok, dap = pcall(require, "dap")

if ok then
  dap.configurations.java = {
    {
      type = "java";
      request = "attach";
      name = "Java Attach";
      hostName = "localhost";
      port = 5005;
    },
  }

  require('dap.ext.vscode').load_launchjs()
end
function resolve_main_class()
  local currentBuffer = vim.fn.fnamemodify(vim.fn.expand("%"), ":r")
  local packageAnchor = "main/java/"
  local packageStart = vim.fn.strridx(currentBuffer, packageAnchor) + vim.fn.strlen(packageAnchor)
  local packagePath = vim.fn.strpart(currentBuffer, packageStart)
  local mainClass = string.gsub(packagePath, "/", ".")

  print(mainClass)

  return mainClass
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

dap.configurations.typescript = {
  {
    name = 'Launch',
    type = 'node2',
    request = 'launch',
    program = '${file}',
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = 'inspector',
    console = 'integratedTerminal',
  },
}

