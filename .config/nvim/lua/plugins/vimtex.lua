return {
  {
    "lervag/vimtex",
    lazy = false, -- VimTeX needs to load right away
    init = function()
      -- Set Zathura as the default PDF viewer
      vim.g.vimtex_view_method = "zathura"

      -- Disable quickfix auto-open if you find it annoying during compilation errors
      vim.g.vimtex_quickfix_mode = 0
    end,
  },
}
