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
          base08 = "#BF5050",
          base09 = "#C4844A",
          base0A = "#CFC75A",
          base0B = "#6FC753",
          base0C = "#50CFC6",
          base0D = "#5066C4",
          base0E = "#C550C5",
          base0F = "#C46D4F",
			})
		end
	}
}
