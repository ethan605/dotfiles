-- Nvim providers
vim.g.loaded_perl_provider = 0
vim.g.loaded_python_provider = 0
vim.g.python3_host_prog = "$HOME/.asdf/shims/python"

-- For blamer.nvim
vim.g.blamer_delay = 500
vim.g.blamer_enabled = true
vim.g.blamer_show_in_visual_modes = false
vim.g.blamer_template = "<author>, <author-time> • <summary>"

-- For fzf.nvim
vim.g.fzf_command_prefix = "Fzf"

-- For markdown-preview
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
vim.opt.termguicolors = true

-- For vim-go
vim.g.go_doc_keywordprg_enabled = false
vim.g.go_fmt_autosave = true
vim.g.go_imports_autosave = true
vim.g.go_metalinter_autosave = true
vim.g.go_mod_fmt_autosave = true

-- For vim-prettier
vim.g["prettier#autoformat"] = 0
vim.g["prettier#autoformat_require_pragma"] = 0
vim.g["prettier#exec_cmd_async"] = 1
vim.g["prettier#exec_cmd_path"] = "~/.asdf/shims/prettier"
vim.g["prettier#quickfix_enabled"] = 0

-- For vista.vim
vim.g.vista_sidebar_width = 50
