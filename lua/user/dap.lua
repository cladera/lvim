local dap = require('dap')

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
