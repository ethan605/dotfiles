require("dashboard").setup({
  theme = "hyper",
  hide = {
    statusline = true,
    tabline = true,
    winbar = true,
  },
  shortcut_type = "letter",
  config = {
    header = {},
    week_header = { enable = true },
    shortcut = {
      { desc = "󰓦 Update", group = "DiffAdd", action = "PackerSync", key = "u" },
      { desc = "󰍉 Check", group = "DiffChange", action = "checkhealth", key = "c" },
      { desc = "󰿅 Quit", group = "DiffDelete", action = "qa", key = "q" },
    },
    packages = { enable = false },
    project = { enable = false },
    mru = { limit = 10, icon = " ", label = "MRU", cwd_only = true },
  },
})
