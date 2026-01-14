---@type LazyPluginSpec
return {
  "nvim-java/nvim-java",
  config = function()
    ---@type java.Config
    ---@diagnostic disable-next-line: missing-fields
    local opts = {
      checks = {
        nvim_version = true,
        nvim_jdtls_conflict = true,
      },

      jdk = { auto_install = false },
      jdtls = { auto_install = true },
      lombok = { enable = false },
      spring_boot_tools = { enable = false },

      java_debug_adapter = { enable = true },
      java_test = { enable = true },
    }

    require("java").setup(opts)
    vim.lsp.enable("jdtls")
  end,
}
