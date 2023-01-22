local harpoon_ok, harpoon = pcall(require, "harpoon")

if not harpoon_ok then
  return;
end

require("harpoon").setup({
  menu = {
    width = vim.api.nvim_win_get_width(0) - 12,
  }
})

local telescope_ok, telescope = pcall(require, "telescope")
local find_cmd = nil

if telescope_ok then
  telescope.load_extension("harpoon")
  find_cmd = ":Telescope harpoon marks<cr>"
else
  find_cmd = ":lua require(\"harpoon.ui\").toggle_quick_menu()<cr>"
end

vim.keymap.set("n", "<F13>", ":lua require('harpoon.ui').nav_file(1)<cr>",
  { silent = true, desc = "Go file 1", noremap = true })
vim.keymap.set("n", "<F14>", ":lua require('harpoon.ui').nav_file(2)<cr>",
  { silent = true, desc = "Go file 2", noremap = true })
vim.keymap.set("n", "<F15>", ":lua require('harpoon.ui').nav_file(3)<cr>",
  { silent = true, desc = "Go file 3", noremap = true })
vim.keymap.set("n", "<F16>", ":lua require('harpoon.ui').nav_file(4)<cr>",
  { silent = true, desc = "Go file 4", noremap = true })

lvim.builtin.which_key.mappings["a"] = {
  name = "Harpoon",
  s = { ":lua require(\"harpoon.mark\").add_file()<cr>", "Add file" },
  f = { find_cmd, "Find" },
  a = { ":lua require(\"harpoon.ui\").toggle_quick_menu()<cr>", "Show list" },
  c = { ":lua require(\"harpoon.mark\").clear_all()<cr>", "Clear all" },
  n = { ":lua require(\"harpoon.ui\").nav_next()<cr>", "Next mark" },
  p = { ":lua require(\"harpoon.ui\").nav_prev()<cr>", "Previous mark" },
  -- "1" = { ":lua require(\"harpoon.ui\").nav_file(1)<cr>", "Goto mark 1" },
}

-- Set wrap true for Harpoon menu
local my_harpoon_group = vim.api.nvim_create_augroup("my_harpoon_group", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  callback = function()
    if vim.bo.filetype ~= "harpoon" then
      return;
    end

    vim.cmd('setlocal wrap')
  end,
  group = my_harpoon_group,
})
