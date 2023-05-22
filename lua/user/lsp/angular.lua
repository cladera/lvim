local util = require("lspconfig.util")

local opts = {
  root_dir = util.root_pattern("project.json")
}

require("lvim.lsp.manager").setup("angularls", opts);
