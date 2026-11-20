---@type vim.lsp.Config
return {
  cmd = { "yaml-language-server", "--stdio" },
  filetypes = { "yaml", "yaml.docker-compose" },
  settings = {
    redhat = {
      telemetry = {
        enabled = false,
      },
    },
  },
}
