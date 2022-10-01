local harpoon_ok = pcall(require, "harpoon")

if not harpoon_ok then
  return;
end

local telescope_ok, telescope = pcall(require, "telescope")

local show_menu_cmd = nil

if telescope_ok then
  telescope.load_extension("harpoon")
  show_menu_cmd = ":Telescope harpoon marks<cr>"
else
  show_menu_cmd = ":lua require(\"harpoon.ui\").toggle_quick_menu()<cr>"
end

lvim.keys.normal_mode[";"] = show_menu_cmd
lvim.keys.normal_mode["<A-m>"] = ":lua require(\"harpoon.ui\").add_file()<cr>"

lvim.builtin.which_key.mappings["a"] = {
  name = "Harpoon",
  s = { ":lua require(\"harpoon.mark\").add_file()<cr>", "Add file" },
  f = { show_menu_cmd, "Find" },
  a = { ":lua require(\"harpoon.ui\").toggle_quick_menu()<cr>", "Show list" },
  c = { ":lua require(\"harpoon.mark\").clear_all()<cr>", "Clear all" },
  n = { ":lua require(\"harpoon.ui\").nav_next()<cr>", "Next mark" },
  p = { ":lua require(\"harpoon.ui\").nav_prev()<cr>", "Previous mark" },
}
