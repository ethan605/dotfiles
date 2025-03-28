return {
  "nvim-java/nvim-java",
  dependencies = {
    "neovim/nvim-lspconfig",
    "mfussenegger/nvim-dap",
  },
  config = function()
    require("java").setup({
      spring_boot_tools = {
        enable = false,
      },
      jdk = {
        auto_install = false,
      },
    })

    require("lspconfig").jdtls.setup({})
  end,
}
