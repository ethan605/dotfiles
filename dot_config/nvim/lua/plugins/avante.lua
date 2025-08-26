---@type LazySpec
return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  version = false,
  ---@type avante.Config
  opts = {
    ---@type avante.ProviderName
    provider = "claude",
    mode = "agentic",
    selector = {
      ---@type avante.SelectorProvider
      provider = "fzf_lua",
      provider_opts = {
        prompt = "Avante> ",
      },
    },
    dual_boost = { enabled = false },
    selection = { enabled = false },
    web_search_engine = {
      provider = "google",
      proxy = nil,
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
        height = 10,
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
