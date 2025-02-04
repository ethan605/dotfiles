return {
	"lewis6991/gitsigns.nvim",
	event = "CursorHold",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {
		sign_priority = 6,
		current_line_blame = true,
		current_line_blame_opts = {
			virt_text = true,
			virt_text_pos = "right_align", -- 'eol' | 'overlay' | 'right_align'
			delay = 500,
			ignore_whitespace = false,
			virt_text_priority = 100,
		},
		current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> • <summary>",
	},
}
