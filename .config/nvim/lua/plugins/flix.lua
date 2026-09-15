return {
  "flix/nvim",
  ft = "flix",
  config = function()
    -- You can pass options to setup, like forcing a floating terminal
    require("flix").setup({
      terminal = { window = "float" },
    })
    vim.lsp.enable("flix")

    -- Add buffer-local keymaps only for Flix files
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "flix",
      callback = function(args)
        local flix_cmd = require("flix.commands").flix_cmd
        local opts = { noremap = true, silent = true, buffer = args.buf }

        vim.keymap.set("n", "<leader>cr", function()
          flix_cmd("run")
        end, vim.tbl_extend("force", opts, { desc = "Run Flix project" }))
        vim.keymap.set("n", "<leader>ct", function()
          flix_cmd("test")
        end, vim.tbl_extend("force", opts, { desc = "Test Flix project" }))
      end,
    })
  end,
}
