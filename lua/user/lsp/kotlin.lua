local util = require("lspconfig.util")

local opts = {
  root_dir = util.root_pattern("nx.json")
}

require("lvim.lsp.manager").setup("kotlin_language_server", opts);
