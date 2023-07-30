local opts = require('yaml-companion').setup();

-- print(vim.inspect(opts))

require("lvim.lsp.manager").setup("yamlls", opts);

