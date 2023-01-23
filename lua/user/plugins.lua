lvim.plugins = {
  { "lunarvim/colorschemes" },
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
  },
  { 'arcticicestudio/nord-vim' },
  { 'tpope/vim-fugitive' },
  { 'tpope/vim-surround' },
  { 'editorconfig/editorconfig-vim' },
  {
    "ThePrimeagen/harpoon",
  },
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    ft = "markdown",
  },
  { "mfussenegger/nvim-jdtls" },
  { "nvim-telescope/telescope-ui-select.nvim" },
  { "doums/darcula" },
  { "catppuccin/nvim" },
  { "lunarvim/darkplus.nvim" },
  { "rose-pine/neovim" },
  { "christianchiarulli/nvim-gps", branch = "text_hl" },
  -- { "Equilibris/nx.nvim" },
  { "mxsdev/nvim-dap-vscode-js" },
  -- { "github/copilot.vim" }
  { "zbirenbaum/copilot.lua",
    event = { "VimEnter" },
    config = function()
      vim.defer_fn(function()
        require("copilot").setup()
      end, 100)
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    after = { "copilot.lua" },
    config = function()
      require("copilot_cmp").setup()
    end,
  },
  { "olexsmir/gopher.nvim" },
  { "leoluz/nvim-dap-go" },
  { "mbbill/undotree"}
}
