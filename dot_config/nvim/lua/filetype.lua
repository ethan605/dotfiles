vim.filetype.add({
  filename = {
    [".envrc"] = "sh",
    ["docker-compose.yml"] = "yaml.docker-compose",
    ["docker-compose.yaml"] = "yaml.docker-compose",
  },
  pattern = {
    [".env.*"] = "config",
    ["docker%-compose.*.yml"] = "yaml.docker-compose",
    ["docker%-compose.*.yaml"] = "yaml.docker-compose",
  },
})
