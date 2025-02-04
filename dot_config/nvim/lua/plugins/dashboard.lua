return {
	"nvimdev/dashboard-nvim",
	event = "VimEnter",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("dashboard").setup({
			theme = "hyper",
			hide = {
				statusline = true,
				tabline = true,
				winbar = true,
			},
			shortcut_type = "number",
			config = {
				header = {},
				week_header = { enable = true },
				shortcut = {
					{ desc = "󰓦 Update", group = "DiffAdd", action = "Lazy update", key = "u" },
					{ desc = "󰍉 Check", group = "DiffChange", action = "checkhealth", key = "c" },
					{ desc = "󰿅 Quit", group = "DiffDelete", action = "qa", key = "q" },
				},
				packages = { enable = true },
				project = { enable = false },
				mru = { limit = 9, icon = " ", label = "MRU", cwd_only = true },
			},
		})
	end,
}
