return {
  -- Install Gruvbox
  { "ellisonleao/gruvbox.nvim" },

  -- Install Kanagawa
  { "rebelot/kanagawa.nvim" },

  -- Configure LazyVim to use one of them as the default
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox", -- Change this to "kanagawa" to switch defaults
    },
  },
}
