lvim.plugins = {
  { "lunarvim/colorschemes" },
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
  },
  -- {'arcticicestudio/nord-vim'},
  { 'tpope/vim-fugitive' },
  { 'tpope/vim-surround' },
  {
    "lukas-reineke/indent-blankline.nvim",
    -- event = "BufReadPre",
    config = function()
      require("user.blankline").config()
    end,
  },
  { 'editorconfig/editorconfig-vim' },
  {
    "ThePrimeagen/harpoon",
  },
  {
    "folke/todo-comments.nvim",
    config = function()
      require("user.todo_comments").config()
    end,
  },
  -- {
  --   "iamcco/markdown-preview.nvim",
  --   run = "cd app && npm install",
  --   ft = "markdown",
  -- },
  { "mfussenegger/nvim-jdtls" },
  { "nvim-telescope/telescope-ui-select.nvim" },
  { "rcarriga/nvim-dap-ui" },
  { "doums/darcula" },
  { "folke/tokyonight.nvim" },
  -- { "lunarvim/colorschemes" }, -- A bunch of colorschemes you can try out
  { "lunarvim/darkplus.nvim" },
  { "rose-pine/neovim" },
  { "christianchiarulli/nvim-gps", branch = "text_hl" }
}
