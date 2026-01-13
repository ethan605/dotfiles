---@type LazyPluginSpec
return {
  "SmiteshP/nvim-navic",
  ---@module "nvim-navic"
  ---@type Options
  opts = {
    click = false,
    highlight = true,
    safe_output = true,
    lsp = {
      auto_attach = true,
      preference = {
        "pyright",
        "ruff",
      },
    },
  },
}
