---@type LazySpec
return {
  "nvim-java/nvim-java",
  dependencies = {
    { "mason-org/mason.nvim",           version = "^1.0.0" },
    { "mason-org/mason-lspconfig.nvim", version = "^1.0.0" },
    "neovim/nvim-lspconfig",
    "mfussenegger/nvim-dap",
  },
  config = function()
    ---@type java.Config
    local opts = {
      root_markers = {
        "settings.gradle",
        "settings.gradle.kts",
        "pom.xml",
        "build.gradle",
        "mvnw",
        "gradlew",
        "build.gradle",
        "build.gradle.kts",
        ".git",
      },
      java_debug_adapter = { enable = true },
      java_test = { enable = true },
      jdk = { auto_install = false },
      jdtls = { auto_install = true },
      lombok = { enable = false },
      spring_boot_tools = { enable = false },

      notifications = {
        dap = true,
      },
      verification = {
        invalid_order = true,
        duplicate_setup_calls = true,
        invalid_mason_registry = false,
      },
      mason = {
        registries = {
          "github:nvim-java/mason-registry",
        },
      },
    }

    require("java").setup(opts)
    require("lspconfig").jdtls.setup({})
  end,
}
