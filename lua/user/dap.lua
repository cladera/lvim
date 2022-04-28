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

