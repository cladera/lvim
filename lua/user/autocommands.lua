-- Set no expandtab for Makefiles
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  callback = function()
    if vim.bo.filetype ~= "make" then
      return;
    end

    vim.opt_local.expandtab = false
  end
})

-- change to tabs for php
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  callback = function()
    if vim.bo.filetype ~= "php" then
      return;
    end

    vim.cmd('setlocal autoindent')
    vim.cmd('setlocal noexpandtab')
    vim.cmd('setlocal tabstop=4')
    vim.cmd('setlocal shiftwidth=4')
  end
})

-- Winbar
vim.api.nvim_create_autocmd({ "CursorMoved", "BufWinEnter", "BufFilePost", "InsertEnter", "BufWritePost" }, {
  callback = function()
    local winbar = require("user.winbar")
    pcall(winbar.get_winbar, {})
  end,
})

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  callback = function()
    if vim.bo.filetype ~= "xml" then
      return;
    end

    if vim.fn.expand("%:t") ~= "pom.xml" then
      return;
    end

    vim.cmd('setlocal autoindent')
    vim.cmd('setlocal noexpandtab')
    vim.cmd('setlocal tabstop=4')
    vim.cmd('setlocal shiftwidth=4')
  end
})

