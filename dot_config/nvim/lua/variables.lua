-- Nvim providers
vim.g.loaded_perl_provider = 0
vim.g.loaded_python_provider = 0
vim.g.python3_host_prog = "$HOME/.asdf/shims/python"

-- For markdown-preview
vim.g.mkdp_filetypes = { "markdown" }
vim.g.mkdp_preview_options = {
	content_editable = false,
	disable_filename = false,
	disable_sync_scroll = false,
	hide_yaml_meta = true,
	maid = {
		sequence = {
			showSequenceNumbers = true,
		},
	},
	sync_scroll_type = "middle",
}

-- For nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- For vim-prettier
vim.g["prettier#autoformat"] = 0
vim.g["prettier#autoformat_require_pragma"] = 0
vim.g["prettier#exec_cmd_async"] = 1
vim.g["prettier#exec_cmd_path"] = "~/.asdf/shims/prettier"
vim.g["prettier#quickfix_enabled"] = 0
