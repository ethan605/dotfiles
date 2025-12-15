vim.filetype.add({
  filename = {
    [".envrc"] = "sh",
    [".zhistory"] = "zsh",
    ["docker-compose.yml"] = "yaml.docker-compose",
    ["docker-compose.yaml"] = "yaml.docker-compose",
  },
  pattern = {
    [".env.*"] = "config",
    ["docker%-compose.*.yml"] = "yaml.docker-compose",
    ["docker%-compose.*.yaml"] = "yaml.docker-compose",
  },
  extension = {
    bash = "bash",
    http = "http",
  },
})
