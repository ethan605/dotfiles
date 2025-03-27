return {
  cmd = { "bash-language-server", "start" },
  filetypes = { "zsh", "bash", "sh" },
  settings = {
    bashIde = {
      globPattern = "*@(.sh|.inc|.bash|.command)",
    },
  },
}
