---@type vim.lsp.Config
return {
  cmd = { "jsonnet-language-server" },
  filetypes = { "jsonnet", "libsonnet" },
  root_markers = { "jsonnetfile.json", ".git" },
}
