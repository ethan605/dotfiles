vim.filetype.add({
  pattern = {
    [".env.*"] = "config",
    ["docker%-compose.*.yaml"] = "yaml.docker-compose",
  },
})
