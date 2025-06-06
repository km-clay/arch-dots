
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Normal mode
map("n", "<F3>", "<cmd>Telescope find_files<CR>", opts)
map("n", "!t", "<cmd>UndotreeToggle<CR>", opts)
map("n", "!a", "gg<S-v>G", opts)
map("n", "!ca", vim.lsp.buf.code_action, opts)
map("n", "!fmt", vim.lsp.buf.format, opts)
map("n", "!df", vim.diagnostic.open_float, opts)
map("n", "<S-Tab>", "<C-W>W", opts)
map("n", "<Tab>", "<C-w>w", opts)
map("n", "!cq", "<cmd>COQnow<CR>", opts)
map("n", "]d", function()
  vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
end, opts)

map("n", "[d", function()
  vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
end, opts)

-- Normal + Terminal mode
map({ "n", "t" }, "<F2>", "<cmd>FloatermToggle def_term<CR>", opts)
