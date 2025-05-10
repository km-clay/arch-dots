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
          base03 = "#20251B",
          base04 = "#81807D",
          base05 = "#CCCCCC",
          base06 = "#AAAAAA",
          base07 = "#666666",
          base08 = "#9C3F3F",
          base09 = "#9C6C3F",
          base0A = "#9C943F",
          base0B = "#559C3F",
          base0C = "#3F9C96",
          base0D = "#3F539C",
          base0E = "#9C3F9C",
          base0F = "#9c583f",
			})
		end
	}
}
