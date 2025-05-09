local autocmd = vim.api.nvim_create_autocmd

-- Save folds, view, etc. when leaving a buffer window
autocmd("BufWinLeave", {
  pattern = "*",
  command = "silent! mkview",
  desc = "Save session window settings to be loaded next time the file is opened",
})

-- Load view when entering a buffer window
autocmd("BufWinEnter", {
  pattern = "*",
  command = "silent! loadview",
  desc = "Load previous session window settings for the opened file (folds, cursor pos, etc)",
})

-- Start default floaterm window on startup
autocmd("VimEnter", {
  pattern = "*",
  command = "silent! FloatermNew --name=def_term --width=0.8 --height=0.8 --wintype=topright --silent",
  desc = "Start the floaterm window",
})
