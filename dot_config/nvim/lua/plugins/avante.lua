---@type LazySpec
return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  version = false,
  ---type avante.Config
  opts = {
    provider = "gemini",
    gemini_api_key = vim.env.GEMINI_API_KEY,
  },
  build = "make",
  dependencies = {
    "hrsh7th/nvim-cmp",
    "ibhagwan/fzf-lua",
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "nvim-treesitter/nvim-treesitter",
  },
}
