-- Option A: Hard Wrapping (Recommended for LaTeX and Git)
-- Automatically inserts a newline when you type past 80 characters.
--vim.opt_local.textwidth = 80
--vim.opt_local.formatoptions:append("t") -- Auto-wrap text using textwidth

-- Option B: Soft Wrapping (Visual only)
-- If you prefer one long continuous line that visually wraps to fit your screen:
vim.opt_local.wrap = true
vim.opt_local.linebreak = true
