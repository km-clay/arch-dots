if vim.g.started_by_firenvim == true then
	vim.o.laststatus = 0
end
if vim.g.neovide then
	vim.g.neovide_refresh_rate = 144
	vim.g.neovide_cursor_vfx_mode = "sonicboom"
	vim.g.neovide_cursor_animate_in_insert_mode = false
end

vim.g.vimwiki_list = {{path = '~/vimwiki/', syntax = 'markdown', ext = '.md'}}

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.termguicolors = true
vim.opt.ruler = true
vim.opt.scrolloff = 6
vim.opt.undofile = true
vim.opt.foldmethod = "manual"
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.textwidth = 0
vim.opt.breakat = " \t!@*-+;:,./?"
vim.opt.guifont = "EnvyCodeR Nerd Font Mono:h18"

vim.g.mapleader = "!"
vim.g.rust_recommended_style = 0

vim.diagnostic.config({
	signs = false,
	virtual_text = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
})
