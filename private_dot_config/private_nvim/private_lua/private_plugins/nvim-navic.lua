---@type LazyPluginSpec
return {
  "SmiteshP/nvim-navic",
  ---@module "nvim-navic"
  ---@type Options
  opts = {
    click = true,
    highlight = true,
    safe_output = true,
    lsp = {
      auto_attach = true,
      preference = {
        -- python LSP
        -- "pyrefly",
        "pyright",
        "ruff",
      },
    },
  },
}
