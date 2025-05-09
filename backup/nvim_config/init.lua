-- Options
if vim.g.neovide then
	vim.g.neovide_refresh_rate = 144
	vim.g.neovide_cursor_vfx_mode = ""
	vim.g.neovide_cursor_animate_in_insert_mode = false
end

vim.g.vimwiki_list = {{path = '~/vimwiki/', syntax = 'markdown', ext = '.md'}}

vim.lsp.enable('intelephense')

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
vim.opt.guifont = "Fira Code:h18"

vim.diagnostic.config({
	virtual_text = true,
	update_in_insert = false,
	signs = false,
})

vim.g.mapleader = "!"
vim.g.rust_recommended_style = 0

-- Plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "vim-airline/vim-airline",
    config = function()
      vim.g.airline_left_sep = ''
      vim.g.airline_right_sep = ''
      vim.g.airline_powerline_fonts = 1
      vim.g.airline_theme = "dark"
      vim.g.airline_section_x = ''
      vim.g.airline_section_y = ''
      vim.g.airline_skip_empty_sections = 1
    end,
  },
  {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("alpha").setup(require("alpha.themes.dashboard").config)
    end,
  },
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"hrsh7th/cmp-nvim-lsp-document-symbol",
		},
		config = function()
			local cmp = require("cmp")

			cmp.setup({
				mapping = cmp.mapping.preset.insert({
					["<Tab>"] = cmp.mapping.select_next_item(),
					["<S-Tab>"] = cmp.mapping.select_prev_item(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<C-Space>"] = cmp.mapping.complete(),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "nvim_lsp_signature_help" },
					{ name = "nvim_lsp_document_symbol" },
					{ name = "path" },
					{ name = "buffer" },
				}),
			})
		end,
	},
	{
		"ms-jpq/coq_nvim",
		branch = "coq",
		dependencies = {
			{ "ms-jpq/coq.artifacts", branch = "artifacts" },
			{ "ms-jpq/coq.thirdparty", branch = "3p" },
		},
		config = function()
			vim.g.coq_settings = {
				auto_start = "shut-up", -- disables auto-start
			}
		end,
	},
	{
		"j-hui/fidget.nvim",
		tag = "legacy", -- use this until you're ready for the rewritten v1 branch
		config = function()
			require("fidget").setup({
				text = {
					spinner = "dots",
				},
				window = {
					border = "rounded",
				},
				notify = {
					override_vim_notify = true,
				},
			})
		end,
	},
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        signs = {
          add          = { text = "│" },
          change       = { text = "/" },
          delete       = { text = "-" },
          topdelete    = { text = "-" },
          changedelete = { text = "\\" },
        },
      })
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl", -- Required in recent versions to use the new setup API
    config = function()
      require("ibl").setup({
        -- Uncomment the following lines if you want to customize the indent character
        -- indent = {
        --   char = "│",
        -- },
      })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-nvim-lsp-document-symbol",
      "dcampos/nvim-snippy",
      "dcampos/cmp-snippy",
    },
    config = function()
      local cmp = require("cmp")

      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ["<C-o>"] = cmp.mapping.close_docs(),
          ["<C-i>"] = cmp.mapping.open_docs(),
          ["<C-j>"] = cmp.mapping.scroll_docs(-4),
          ["<C-k>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = function(fallback)
            if cmp.visible() then
              cmp.confirm()
            else
              fallback()
            end
          end,
          ["<Tab>"] = function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end,
          ["<S-Tab>"] = function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end,
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "nvim_lsp_signature_help" },
          { name = "nvim_lsp_document_symbol" },
          { name = "path" },
          { name = "buffer" },
          { name = "snippy" },
        }),
        window = {
          completion = {
            border = "rounded",
          },
        },
      })
    end,
  },
  {
	  "neovim/nvim-lspconfig",
	  config = function()
		  local lspconfig = require("lspconfig")

		  local servers = {
			  bashls = {},
				intelephense = {},
			  ccls = {},
			  clangd = {},
			  cmake = {},
			  eslint = {},
			  html = {},
			  jsonls = {},
			  lua_ls = {},
			  marksman = {},
			  jdtls = {},
			  pyright = {},
			  sqls = {},
			  hls = {
				  settings = {},
			  },
		  }

		  -- Attach servers
		  local capabilities = require("cmp_nvim_lsp").default_capabilities()

		  for server, config in pairs(servers) do
			  config.capabilities = capabilities
			  lspconfig[server].setup(config)
		  end
	  end,
  },
  {
	  "mrcjkb/rustaceanvim",
	  version = "^4", -- ensures compatibility with latest stable Rustacean releases
	  ft = { "rust" },
	  config = function()
		  vim.g.rustaceanvim = {
			  server = {
				  autoAttach = true,
			  },
			  dap = {
				  adapter = false,
			  },
		  }
	  end,
  },
  {
	  "dstein64/nvim-scrollview",
	  config = function()
		  require("scrollview").setup({
			  signs_on_startup = { "diagnostics" },
			  diagnostics_error_symbol = "■",
			  diagnostics_warn_symbol = "■",
			  diagnostics_hint_symbol = "■",
			  diagnostics_info_symbol = "■",
			  scrollview_character = "│",
		  })
	  end,
  },
  {
	  "nvim-telescope/telescope.nvim",
	  dependencies = { "nvim-lua/plenary.nvim" },
	  config = function()
		  require("telescope").setup({
			  defaults = {
				  file_ignore_patterns = { "%.snap", "%.git/" },
			  },
			  pickers = {
				  find_files = {
					  hidden = true,
				  },
			  },
		  })
	  end,
  },
  {
	  "andymass/vim-matchup",
	  config = function()
		  vim.g.matchup_surround_enabled = 1
		  vim.g.matchup_text_obj_enabled = 1
		  vim.g.matchup_motion_enabled = 1
		  vim.g.matchup_motion_cursor_end = 1
		  vim.g.matchparen_deferred_hi_surround_always = 1
		  vim.g.matchparen_offscreen = { method = "popup" }

		  vim.g.matchup_matchparen_enabled = 1
		  vim.g.matchup_matchparen_deferred = 1

		  vim.g.matchup_matchparen_hi_surround_always = 1
		  vim.g.matchup_matchparen_offscreen = { method = "popup" }

		  vim.g.matchup_matchparen_timeout = 300

		  -- Treesitter integration
		  vim.g.matchup_matchparen_insert_timeout = 60
		  vim.g.matchup_matchparen_deferred_show_delay = 150
		  vim.g.matchup_matchparen_deferred_hide_delay = 700
		  vim.g.matchup_matchparen_show_offscreen = 1
		  vim.g.matchup_matchparen_status_offscreen = 1

		  vim.g.matchup_enable = 1
		  vim.g.matchup_tree_sitter_enabled = 1
		  vim.g.matchup_include_match_words = 1
	  end,
	  event = "VeryLazy",
  },
  {
	  "RRethy/nvim-base16",
	  priority = 1000,
	  config = function()
		  vim.cmd.colorscheme("base16-chalk")
	  end,
  },
  { "LnL7/vim-nix" },
	{ "vimwiki/vimwiki" },
  { "RRethy/nvim-treesitter-endwise" },
  { "mbbill/undotree" },
  { "milisims/nvim-luaref" }, -- assuming this is your `helpview`
  { "voldikss/vim-floaterm" },
  { "tpope/vim-fugitive" },

  -- Restore cursor position on file open
  { "ethanholz/nvim-lastplace" },

  -- Markdown preview
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    ft = { "markdown" },
  },

  -- Show mark locations in the signcolumn
  { "chentoast/marks.nvim", config = true },

  -- Surround text objects easily
  { "kylechui/nvim-surround", version = "*", config = true },

  -- Rainbow parentheses
  { "hiphish/rainbow-delimiters.nvim" },

  -- Render markdown in floating windows
  { "MeanderingProgrammer/markdown.nvim", ft = "markdown", dependencies = { "nvim-treesitter/nvim-treesitter" }, config = true },

  -- Treesitter syntax parsing
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  -- Trim trailing whitespace on save
  { "cappyzawa/trim.nvim", config = true },

  -- LSP diagnostics explorer
  { "folke/trouble.nvim", dependencies = { "nvim-tree/nvim-web-devicons" }, config = true },

  -- Devicons for file types
  { "nvim-tree/nvim-web-devicons" },
})

-- Autocmd

-- Save view (folds, cursor pos, etc.) on buffer leave
vim.api.nvim_create_autocmd("BufWinLeave", {
  pattern = "*",
  command = "silent! mkview",
  desc = "Save session window settings to be loaded next time the file is opened",
})

-- Load view when re-entering buffer
vim.api.nvim_create_autocmd("BufWinEnter", {
  pattern = "*",
  command = "silent! loadview",
  desc = "Load previous session window settings for the opened file (folds, cursor pos, etc)",
})

-- Start Floaterm on VimEnter
vim.api.nvim_create_autocmd("VimEnter", {
  pattern = "*",
  command = "silent! FloatermNew --name=def_term --width=0.8 --height=0.8 --wintype=topright --silent",
  desc = "Start the floaterm window",
})

-- Keymaps

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Normal mode mappings
map("n", "!fs", "<cmd>Telescope find_files<CR>", opts)
map("n", "!t", "<cmd>UndotreeToggle<CR>", opts)
map("n", "!a", "gg<S-V>G", opts)
map("n", "!ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
map("n", "!fmt", "<cmd>lua vim.lsp.buf.format()<CR>", opts)
map("n", "!df", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
map("n", "<S-Tab>", "<C-W>W", opts)
map("n", "<Tab>", "<C-w>w", opts)
map("n", "<F3>", "<cmd>Telescope find_files<CR>", opts)
map("n", "!cq", "<cmd>COQnow<CR>", opts)

-- Normal + Terminal mode
map({ "n", "t" }, "<F2>", "<cmd>FloatermToggle def_term<CR>", opts)
