---@type LazySpec
return {
  "nvim-java/nvim-java",
  dependencies = {
    "neovim/nvim-lspconfig",
    "mfussenegger/nvim-dap",
  },
  config = function()
    ---type java.Config
    local opts = {
      spring_boot_tools = {
        enable = false,
      },
      jdk = {
        auto_install = false,
      },
    }

    require("java").setup(opts)
    require("lspconfig").jdtls.setup({})
  end,
}
