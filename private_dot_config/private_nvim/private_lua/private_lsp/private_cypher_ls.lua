---@type vim.lsp.Config
return {
  cmd = { "cypher-language-server", "--stdio" },
  filetypes = { "cypher" },
  root_markers = { ".git" },
}
