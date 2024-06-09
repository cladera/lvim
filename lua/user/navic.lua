local navic_ok, navic = pcall(require, "nvim-navic")

if not navic_ok then
  return
end


navic.setup({
  lsp = {
    auto_attach = true
  }
})

vim.o.statusline = "%{%v:lua.require'nvim-navic'.get_location()%}"
