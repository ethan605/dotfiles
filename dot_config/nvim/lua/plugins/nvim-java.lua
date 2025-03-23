return {
  "nvim-java/nvim-java",
  opts = {
    spring_boot_tools = {
      enable = false,
    },
    jdk = {
      auto_install = false,
    },
  },
  dependencies = { "mfussenegger/nvim-dap" },
}
