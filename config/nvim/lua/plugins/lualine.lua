return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local lualine = require("lualine")

    -- Color table, conditions, ins_left/right setup
		local colors = {
			base00 = "0F1419",
			base01 = "131721",
			base02 = "272D38",
			base03 = "3E4B59",
			base04 = "BFBDB6",
			base05 = "E6E1CF",
			base06 = "E6E1CF",
			base07 = "F3F4F5",
			base08 = "F07178",
			base09 = "FF8F40",
			base0A = "FFB454",
			base0B = "B8CC52",
			base0C = "95E6CB",
			base0D = "59C2FF",
			base0E = "D2A6FF",
			base0F = "E6B673",
		}

    local conditions = {
      buffer_not_empty = function()
        return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
      end,
      hide_in_width = function()
        return vim.fn.winwidth(0) > 80
      end,
      check_git_workspace = function()
        local filepath = vim.fn.expand('%:p:h')
        local gitdir = vim.fn.finddir('.git', filepath .. ';')
        return gitdir and #gitdir > 0 and #gitdir < #filepath
      end,
    }

    local config = {
      options = {
        component_separators = '',
        section_separators = '',
        theme = {
          normal = { c = { fg = colors.base05, bg = colors.base01 } },
          inactive = { c = { fg = colors.base05, bg = colors.base01 } },
        },
      },
      sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_y = {},
        lualine_z = {},
        lualine_c = {},
        lualine_x = {},
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_y = {},
        lualine_z = {},
        lualine_c = {},
        lualine_x = {},
      },
    }

		-- Inserts a component in lualine_c at left section
		local function ins_left(component)
			table.insert(config.sections.lualine_c, component)
		end

		-- Inserts a component in lualine_x at right section
		local function ins_right(component)
			table.insert(config.sections.lualine_x, component)
		end

		ins_left {
			function()
				return '▊'
			end,
			color = { fg = "#9C903F" }, -- Sets highlighting of component
			padding = { left = 0, right = 1 }, -- We don't need space before this
		}

		ins_left {
			-- filesize component
			'filesize',
			cond = conditions.buffer_not_empty,
		}

		ins_left {
			'filename',
			cond = conditions.buffer_not_empty,
			color = { fg = colors.base0D, gui = 'bold' },
		}

		ins_left { 'location' }

		ins_left { 'progress', color = { fg = colors.base05, gui = 'bold' } }

		ins_left {
			'diagnostics',
			sources = { 'nvim_diagnostic' },
			symbols = { error = ' ', warn = ' ', info = ' ' },
			diagnostics_color = {
				error = { fg = colors.base08 },
				warn = { fg = colors.base0C },
				info = { fg = colors.base0D },
			},
		}

		-- Insert mid section. You can make any number of sections in neovim :)
		-- for lualine it's any number greater then 2
		ins_left {
			function()
				return '%='
			end,
		}

		ins_left {
			-- Lsp server name .
			function()
				local msg = 'No Active Lsp'
				local buf_ft = vim.api.nvim_get_option_value('filetype', { buf = 0 })
				local clients = vim.lsp.get_clients()
				if next(clients) == nil then
					return msg
				end
				for _, client in ipairs(clients) do
					local filetypes = client.config.filetypes
					if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
						return client.name
					end
				end
				return msg
			end,
			icon = ' LSP:',
			color = { fg = '#ffffff', gui = 'bold' },
		}

		-- Add components to right sections
		ins_right {
			'o:encoding', -- option component same as &encoding in viml
			fmt = string.upper, -- I'm not sure why it's upper case either ;)
			cond = conditions.hide_in_width,
			color = { fg = colors.base0B, gui = 'bold' },
		}

		ins_right {
			'fileformat',
			fmt = string.upper,
			icons_enabled = false, -- I think icons are cool but Eviline doesn't have them. sigh
			color = { fg = colors.base0B, gui = 'bold' },
		}

		ins_right {
			'branch',
			icon = '',
			color = { fg = colors.base0E, gui = 'bold' },
		}

		ins_right {
			'diff',
			-- Is it me or the symbol for modified us really weird
			symbols = { added = ' ', modified = '󰝤 ', removed = ' ' },
			diff_color = {
				added = { fg = colors.base0B },
				modified = { fg = colors.base0A },
				removed = { fg = colors.base08 },
			},
			cond = conditions.hide_in_width,
		}

		ins_right {
			function()
				return '▊'
			end,
			color = { fg = "#9C903F" },
			padding = { left = 1 },
		}

		lualine.setup(config)
	end
}
