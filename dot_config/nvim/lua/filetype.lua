vim.filetype.add({
  extension = {
    env = "config",
  },
  filename = {
    [".env"] = "config",
  },
  pattern = {
    [".env.*"] = "config",
  },
})
