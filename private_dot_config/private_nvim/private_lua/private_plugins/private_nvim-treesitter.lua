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
      "bash", "zsh",
      "cpp", "cmake", "make",
      "go", "gosum", "java", "nix", "python", "rust",
      "javascript", "jsx", "typescript", "tsx",
      "comment", "json", "json5", "yaml",
    })
  end,
}
