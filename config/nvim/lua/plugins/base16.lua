return {
	{
		"RRethy/nvim-base16",
		lazy = false,
		priority = 1000,
		config = function()
			require('base16-colorscheme').setup({
          base00 = "#0e0f0c",
          base01 = "#3D4636",
          base02 = "#9C903F",
          base03 = "#2C2B38",
          base04 = "#A3A3A3",
          base05 = "#CCCCCC",
          base06 = "#AAAAAA",
          base07 = "#666666",
          base08 = "#7D3232",
          base09 = "#9C7A3F",
          base0A = "#9C903F",
          base0B = "#7A9C3F",
          base0C = "#3F9C62",
          base0D = "#3F7A9C",
          base0E = "#903F9C",
          base0F = "#364546",
			})
		end
	}
}
