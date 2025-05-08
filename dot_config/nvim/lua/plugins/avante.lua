---@type LazySpec
return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  version = false,
  ---type avante.Config
  opts = {
    ---@type avante.ProviderName
    provider = "gemini",
    gemini_api_key = vim.env.GEMINI_API_KEY,
    ---@type AvanteHintsConfig
    hints = { enabled = false },
    selector = {
      ---@type avante.SelectorProvider
      provider = "fzf_lua",
      provider_opts = {
        prompt = "Avante> ",
      },
    },
    mappings = {
      cancel = {
        normal = { "<C-c>" },
      },
    },
    windows = {
      position = "right",
      wrap = true,
      width = 40,
      input = {
        height = 5,
        prompt_hl_group = "Comment",
      },
      sidebar_header = { enabled = false },
      edit = { start_insert = false },
      ask = { start_insert = false },
    },
  },
  build = "make",
  dependencies = {
    "hrsh7th/nvim-cmp",
    "ibhagwan/fzf-lua",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
    "nvim-treesitter/nvim-treesitter",
  },
}
