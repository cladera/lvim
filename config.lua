--[[
lvim is the global options object

linters should be
filled in as strings with either
a global executable or a path to
an executable
-- ]]
-- these are example configs feel free to change to whatever you want

-- general
vim.g.catppuccin_flavour = "macchiato"
lvim.log.level = "warn"
lvim.format_on_save = false
-- lvim.colorscheme = "nord"
-- lvim.colorscheme = "darcula"
-- lvim.colorscheme = "spacedark"
lvim.colorscheme = "darkplus"
lvim.colorscheme = "tokyonight-night"
lvim.colorscheme = "catppuccin"

require "user.plugins"
require "user.autocommands"
require "user.dap"
require "user.dap.ui"
require "user.gps"
require "user.harpoon"
-- require "user.null-ls.checkstyle"

vim.opt.number = true
vim.opt.relativenumber = true

-- keymappings [view all the defaults by pressing <leader>lk]
lvim.leader = "space"

-- add your own keymapping
lvim.keys.normal_mode["<c-s>"] = ":w<cr>"
lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<cr>"
lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<cr>"
lvim.keys.insert_mode["jk"] = "<Esc>"
lvim.keys.insert_mode["jj"] = "<Esc>"
lvim.keys.insert_mode["kk"] = "<Esc>"

-- unmap a default keymapping
-- lvim.keys.normal_mode["<c-up>"] = ""
-- edit a default keymapping
-- lvim.keys.normal_mode["<c-q>"] = ":q<cr>"

-- change telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
-- we use protected-mode (pcall) just in case the plugin wasn't loaded yet.
-- local _, actions = pcall(require, "telescope.actions")
-- lvim.builtin.telescope.defaults.mappings = {
--   -- for input mode
--   i = {
--     ["<c-j>"] = actions.move_selection_next,
--     ["<c-k>"] = actions.move_selection_previous,
--     ["<c-n>"] = actions.cycle_history_next,
--     ["<c-p>"] = actions.cycle_history_prev,
--   },
--   -- for normal mode
--   n = {
--     ["<c-j>"] = actions.move_selection_next,
--     ["<c-k>"] = actions.move_selection_previous,
--   },
-- }

-- use which-key to add extra bindings with the leader-key prefix
-- lvim.builtin.which_key.mappings["p"] = { "<cmd>telescope projects<cr>", "projects" }
lvim.builtin.which_key.mappings["t"] = {
  name = "+trouble",
  r = { "<cmd>trouble lsp_references<cr>", "references" },
  f = { "<cmd>trouble lsp_definitions<cr>", "definitions" },
  d = { "<cmd>trouble lsp_document_diagnostics<cr>", "diagnostics" },
  q = { "<cmd>trouble quickfix<cr>", "quickfix" },
  l = { "<cmd>trouble loclist<cr>", "locationlist" },
  w = { "<cmd>trouble lsp_workspace_diagnostics<cr>", "diagnostics" },
}

lvim.builtin.which_key.mappings["m"] = {
  name = "+Maven",
  p = { "<cmd>TermExec cmd=\"mvn package\"<CR>", "Package" },
  t = { "<cmd>TermExec cmd=\"mvn test\"<CR>", "Test" },
  c = { "<cmd>TermExec cmd=\"mvn compile\"<CR>", "Complie" },
  C = { "<cmd>TermExec cmd=\"mvn clean compile\"<CR>", "Clean Complie" },
  i = { "<cmd>TermExec cmd=\"mvn install\"<CR>", "Install" },
  I = { "<cmd>TermExec cmd=\"mvn clean install\"<CR>", "Clean Install" },
  v = { "<cmd>TermExec cmd=\"mvn verify\"<CR>", "Verify" },
  V = { "<cmd>TermExec cmd=\"mvn clean verify\"<CR>", "Clean Verify" },
  u = { "<cmd>TermExec cmd=\"mvn clean\"<CR>", "Clean" },
  g = {
    name = "Generate",
    m = { "<cmd>TermExec cmd=\"mvn archetype:generate\"<CR>", "Module" },
    c = { "<cmd>TermExec cmd=\"mvn archetype:generate -DarchetypeGroupId=io.cucumber -DarchetypeArtifactId=cucumber-archetype -DarchetypeVersion=7.0.0\"<CR>", "Cucumber Module" },
    s = { "<cmd>TermExec cmd=\"mvn archetype:generate -DarchetypeGroupId=com.github.netyjq -DarchetypeArtifactId=spring-boot-archetype -DarchetypeVersion=0.0.2.release\"<CR>", "SpringBoot" },
  },
}

lvim.builtin.which_key.mappings["g"]["g"] = {
  "<cmd>Git<cr>", "Open changed files view",
}
lvim.builtin.which_key.mappings["g"]["f"] = {
  "<cmd>Git commit<cr>", "Commit changes"
}

lvim.builtin.which_key.mappings["G"] = {
  name = "+Resolve Conflicts",
  f = { "<cmd>diffget //2<cr>", "Accept Current" },
  j = { "<cmd>diffget //3<cr>", "Accept Incomping" },
}

lvim.builtin.which_key.mappings["l"]["g"] = {
  "<cmd>lua require('jdtls').organize_imports()<cr>", "Organize Imports"
}

local code_actions_copy = lvim.builtin.which_key.mappings["l"]["a"]
lvim.builtin.which_key.mappings["l"]["a"] = {
  "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Actions"
}
lvim.builtin.which_key.mappings["l"]["A"] = code_actions_copy;

lvim.builtin.cmp.confirm_opts.select = true;

lvim.builtin.which_key.mappings["r"] = {
  name = "Run+",
  c = { "<cmd>lua require('jdtls').test_class()<cr>", "Java Tests: Class" },
  m = { "<cmd>lua require('jdtls').test_nearest_method()<cr>", "Java Tests: Nearest  method" },
  p = { "<cmd>lua require('jdtls').pick_test()<cr>", "Java Tests: Pick test" },
  f = { "<cmd>lua require('jdtls').fetch_main_configs()<cr>", "Java Tests: Discover main functions" },
}

-- Extract actions
lvim.keys.visual_mode["<c-m>"] = "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>"
lvim.keys.visual_mode["<c-c>"] = "<Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>"

lvim.builtin.which_key.vmappings["e"] = {
  name = "Extract",
  c = { "<Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>", "Constant" },
  m = { "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", "Method" },
}

lvim.builtin.dap.on_config_done = function()
  lvim.builtin.which_key.mappings["d"]["r"] = {
    "<cmd>lua require('dapui').toggle()<cr>", "Toggle Rapl"
  }
end

lvim.builtin.which_key.mappings["S"] = {
  name = "Quick settings",
  j = { ":setlocal ts=4 sw=4<cr>", "Set indent to 4" },
}

-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile

-- lvim.builtin.terminal.active = true
lvim.builtin.dap.active = true

lvim.builtin.nvimtree.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.git.enable = false
lvim.builtin.nvimtree.setup.git.timeout = 400
lvim.builtin.nvimtree.setup.filters.custom = {
  "^\\.settings",
  "^\\.project",
  "^\\.classpath",
  "^\\.factorypath",
  "node_modules",
  ".git",
  ".idea",
  "^\\tmp",
  ".mvn"
}
lvim.builtin.nvimtree.setup.log = {
  enable = false,
  truncate = true,
  types = {
    git = true,
    profile = true
  },
}
lvim.builtin.nvimtree.group_empty = 1

lvim.builtin.project.manual_mode = true

lvim.builtin.fancy_statusline = { active = true } -- enable/disable fancy statusline
if lvim.builtin.fancy_statusline.active then
  require("user.lualine").config()
end

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "c",
  "javascript",
  "json",
  "lua",
  "python",
  "typescript",
  "css",
  "rust",
  "java",
  "yaml",
}

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enabled = true

-- Telescope extensions
lvim.builtin.telescope.extensions['ui-select'] = require("telescope.themes").get_dropdown {
  winblend = 15,
  layout_config = {
    prompt_position = "top",
    width = 80,
    height = 12,
  },
  borderchars = lvim.builtin.telescope.defaults.borderchars,
  border = {},
  previewer = false,
  shorten_path = false,
}

lvim.builtin.telescope.on_config_done = function(telescope)
  telescope.load_extension("ui-select")
end

local user_dashboard = require("user.alpha.dashboard");
lvim.builtin.alpha.dashboard = { config = {}, section = user_dashboard.get_sections() }; 

-- require("telescope").load_extension("ui-select")

-- generic LSP settings

-- ---@usage disable automatic installation of servers
-- lvim.lsp.automatic_servers_installation = false

-- ---@usage Select which servers should be configured manually. Requires `:LvimCacheRest` to take effect.
-- See the full default list `:lua print(vim.inspect(lvim.lsp.override))`

-- ---@usage setup a server -- see: https://www.lunarvim.org/languages/#overriding-the-default-configuration
-- local opts = {} -- check the lspconfig documentation for a list of all possible options
-- vim.list_extend(lvim.lsp.override, { "jdtls" });
-- require("lvim.lsp.manager").setup("jdtls", require('user.jdtls').user_config());

-- you can set a custom on_attach function that will be used for all the language servers
-- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end
-- you can overwrite the null_ls setup table (useful for setting the root_dir function)

-- Replace null_ls by nvim-jdtls
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "jdtls" })
-- require("lvim.lsp.manager").setup("jdtls", require('user.jdtls').user_config());
-- print(vim.inspect(require('user.jdtls').user_config()))

-- lvim.lsp.null_ls.setup = {
--   root_dir = require("lspconfig").util.root_pattern(".git"),
-- }
-- or if you need something more advanced
-- lvim.lsp.null_ls.setup.root_dir = function(fname)
--   if vim.bo.filetype == "javascript" then
--     return require("lspconfig/util").root_pattern("Makefile", ".git", "node_modules")(fname)
--       or require("lspconfig/util").path.dirname(fname)
--   elseif vim.bo.filetype == "php" then
--     return require("lspconfig/util").root_pattern("Makefile", ".git", "composer.json")(fname) or vim.fn.getcwd()
--   else
--     return require("lspconfig/util").root_pattern("Makefile", ".git")(fname) or require("lspconfig/util").path.dirname(fname)
--   end
-- end

-- set a formatter, this will override the language server formatting capabilities (if it exists)
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { exe = "black" },
  { command = "prettier", filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" } }
}
-- -- set additional linters
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  { exe = "flake8" },
  -- {
  --   exe = "eslint_d",
  --   ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
  --   filetypes = { "javascript", "javascriptreact" },
  -- },
}

-- Additional Plugins
-- Now managed in an indepenent file (see require above)
-- lvim.plugins = {
-- }
