---@type LazyPluginSpec
local mason_lock = {
  "zapling/mason-lock.nvim",
  opts = {
    lockfile_path = vim.fn.stdpath("config") .. "/mason-lock.json",
  },
}

---@type LazyPluginSpec
return {
  "mason-org/mason.nvim",
  dependencies = { mason_lock },
  ---@type MasonSettings
  opts = {
    ui = {
      backdrop = 100,
    },
  },
}
