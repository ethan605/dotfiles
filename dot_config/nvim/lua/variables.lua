-- Nvim providers
vim.g.loaded_python_provider = false
vim.g.loaded_perl_provider = false

-- For barbar
vim.g.bufferline = {
  animation = false,
  clickable = false,
  closable = false,
}

-- For blamer.nvim
vim.g.blamer_delay = 500
vim.g.blamer_enabled = true
vim.g.blamer_show_in_visual_modes = false
vim.g.blamer_template = "<author>, <author-time> • <summary>"

-- For indentLine
vim.g.indentLine_char = "·"
vim.g.indentLine_enabled = true

-- For markdown-preview
vim.g.mkdp_preview_options = {
  content_editable = false,
  disable_filename = false,
  disable_sync_scroll = false,
  hide_yaml_meta = true,
  maid = {
    sequence = {
      showSequenceNumbers = true
    }
  },
  sync_scroll_type = "middle",
}

-- For NvimTree
--vim.g.nvim_tree_auto_open = 1
vim.g.nvim_tree_ignore = { ".git", "node_modules" }
vim.g.nvim_tree_git_hl = 1
vim.g.nvim_tree_highlight_opened_files = 1

-- For vim-fugitive
vim.g.fugitive_gitlab_domains = { "https://gitlab.eu-west-1.mgmt.onfido.xyz/" }

-- For vim-go
vim.g.go_doc_keywordprg_enabled = false
vim.g.go_fmt_autosave = true
vim.g.go_imports_autosave = true
vim.g.go_metalinter_autosave = true
vim.g.go_mod_fmt_autosave = true
