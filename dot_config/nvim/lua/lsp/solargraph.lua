---@class vim.lsp.Config
return {
  cmd = { "solargraph", "stdio" },
  filetypes = { "ruby" },
  root_markers = { "Gemfile" },
  init_options = {
    formatting = true,
  },
  settings = {
    solargraph = {
      diagnostics = true,
    },
  },
}
