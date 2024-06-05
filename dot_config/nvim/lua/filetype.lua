vim.filetype.add({
  filename = {
    [".envrc"] = "sh",
  },
  pattern = {
    [".env.*"] = "config",
    ["docker%-compose.*.yaml"] = "yaml.docker-compose",
  },
})
