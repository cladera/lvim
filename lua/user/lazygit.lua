local Terminal = require('toggleterm.terminal').Terminal
local lazygit  = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })

function Lazygit()
  lazygit:toggle()
end

lvim.builtin.which_key.mappings["g"]["g"] = {
  "<cmd>lua Lazygit()<cr>", "Lazygit",
}
