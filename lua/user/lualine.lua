local components = require("lvim.core.lualine.components")

local xmode = vim.deepcopy(components.mode)
xmode.separator = { left = '' }
xmode.padding = { right = 1 }

local xprogress = vim.deepcopy(components.progress)
xprogress.separator = { right = '' }
xprogress.padding = { left = 1 }

lvim.builtin.lualine.options.component_separators = '|';
lvim.builtin.lualine.options.section_separators = { left = '', right = '' };
lvim.builtin.lualine.sections.lualine_a = { xmode }
lvim.builtin.lualine.sections.lualine_z = { xprogress }
