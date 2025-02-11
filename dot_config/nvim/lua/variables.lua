-- Nvim providers
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.python3_host_prog = "$HOME/.asdf/shims/python"

-- TODO: Figure out a better way to provide `g:node_host_prog`
vim.g.loaded_node_provider = 0
-- vim.g.node_host_prog = "$HOME/.asdf/installs/nodejs/$NODE_VERSION/bin/neovim-node-host"

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
