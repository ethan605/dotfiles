-- Nvim providers
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.python3_host_prog = vim.fn.expand("~/.asdf/shims/python")

-- TODO: figure out better way to provide `node_host_prog`
-- vim.g.node_host_prog = vim.fn.expand("~/.asdf/shims/neovim-node-host")

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

-- For vista.vim
vim.g.vista_default_executive = "nvim_lsp"
vim.g.vista_sidebar_width = 50
vim.g.vista_executive_for = {
  zsh = "ctags",
}
vim.g["vista#renderer#enable_icon"] = 1

-- For vim-dadbod-ui
vim.g.db_ui_auto_execute_table_helpers = 0
vim.g.db_ui_auto_execute_table_helpers = 0
vim.g.db_ui_disable_mappings_javascript = 1
vim.g.db_ui_disable_mappings_sql = 1
vim.g.db_ui_disable_progress_bar = 1
vim.g.db_ui_execute_on_save = 0
vim.g.db_ui_use_nerd_fonts = 1
vim.g.db_ui_save_location = vim.fn.expand("~/work/scratch-pad/sql")
vim.g.db_ui_winwidth = 50
