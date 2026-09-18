vim.filetype.add({
  filename = {
    [".envrc"] = "zsh",
    [".zhistory"] = "zsh",
    ["docker-compose.yml"] = "yaml.docker-compose",
    ["docker-compose.yaml"] = "yaml.docker-compose",
  },
  pattern = {
    ["%.env%..*"] = { "config", { priority = 10 } },
    ["docker%-compose%..*%.yml"] = "yaml.docker-compose",
    ["docker%-compose%..*%.yaml"] = "yaml.docker-compose",
  },
  extension = {
    bash = "bash",
    http = "http",
  },
})
