---@type LazyPluginSpec
return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
  config = function()
    local treesitter = require("nvim-treesitter")

    treesitter.setup({
      install_dir = vim.fn.stdpath("data") .. "/site",
    })

    treesitter.install({
      "bash",
      "cmake",
      "comment",
      "cpp",
      "devicetree",
      "go",
      "gosum",
      "java",
      "javascript",
      "json",
      "json5",
      "jsonnet",
      "jsx",
      "kconfig",
      "make",
      "nix",
      "python",
      "rust",
      "scala",
      "terraform",
      "tsx",
      "typescript",
      "yaml",
      "zsh",
    })
  end,
}
