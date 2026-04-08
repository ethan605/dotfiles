-- Nvim providers
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_python3_provider = 0

-- vim.g.node_host_prog = vim.fn.expand("~/.local/share/mise/shims/neovim-node-host")
-- vim.g.ruby_host_prog = vim.fn.expand("~/.local/share/mise/shims/neovim-ruby-host")
-- vim.g.python3_host_prog = vim.fn.expand("~/.local/share/mise/shims/python")

-- Replacing netrw with vifm
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.vifm_replace_netrw = 1
vim.g.vifm_replace_netrw_cmd = "Vifm"
