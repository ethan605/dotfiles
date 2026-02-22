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
      java_debug_adapter = { enable = false },
      java_test = { enable = false },
      lombok = { enable = false },
      spring_boot_tools = { enable = false },
    }

    require("java").setup(opts)
    vim.lsp.enable("jdtls")
  end,
}
