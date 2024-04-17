vim.filetype.add({
  filename = {
    [".env"] = "config",
  },
  pattern = {
    [".env.*"] = "config",
  },
})
