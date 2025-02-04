return {
	"ibhagwan/fzf-lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		"fzf-native",
		winopts = {
			backdrop = 100,
			height = 0.9,
			width = 0.9,
			preview = {
				border = "noborder",
				default = "bat",
				horizontal = "right:50%",
				layout = "horizontal",
				scrollbar = "border",
				scrolloff = "0",
				scrollchars = { "█", "" },
			},
		},
		keymap = {
			builtin = {}, -- clear builtin keymaps
			fzf = {
				["ctrl-e"] = "preview-down",
				["ctrl-y"] = "preview-up",
				["ctrl-d"] = "preview-page-down",
				["ctrl-u"] = "preview-page-up",
			},
		},
		buffers = { formatter = "path.filename_first" },
		files = { formatter = "path.filename_first" },
		grep = { formatter = "path.filename_first" },
		grep_visual = { formatter = "path.filename_first" },
		live_grep = { formatter = "path.filename_first" },
		loclist = { formatter = "path.filename_first" },
		quickfix = { formatter = "path.filename_first" },
		git = {
			files = {
				formatter = "path.filename_first",
				cwd = vim.fn.getcwd(),
			},
			status = { formatter = "path.filename_first" },
		},
		lsp = {
			async_or_timeout = 3000, -- make lsp requests synchronous so they work with none-ls
			finder = { formatter = "path.filename_first" },
			references = { cwd = vim.fn.getcwd() },
		},
	},
}
