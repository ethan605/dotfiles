---@type LazySpec
return {
  "yetone/avante.nvim",
  build = "make",
  dependencies = {
    "hrsh7th/nvim-cmp",
    "ibhagwan/fzf-lua",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
    "nvim-treesitter/nvim-treesitter",
  },
  event = "VeryLazy",
  version = false,
  ---@type avante.Config
  opts = {
    ---@type avante.Mode
    mode = "agentic",
    ---@type avante.ProviderName
    provider = "claude",
    ---@type avante.ProviderName
    auto_suggestions_provider = "claude",
    selector = {
      ---@type avante.SelectorProvider
      provider = "fzf_lua",
      provider_opts = {
        prompt = "Avante> ",
      },
    },
    dual_boost = {
      enabled = true,
      first_provider = "claude",
      second_provider = "gemini",
      prompt =
      "Based on the two reference outputs below, generate a response that incorporates elements from both but reflects your own judgment and unique perspective. Do not provide any explanation, just give the response directly. Reference Output 1: [{{provider1_output}}], Reference Output 2: [{{provider2_output}}]",
      timeout = 60000, -- Timeout in milliseconds
    },
    selection = { enabled = false },
    behaviour = {
      auto_apply_diff_after_generation = false,
      auto_set_highlight_group = true,
      auto_set_keymaps = true,
      auto_suggestions = false,
      support_paste_from_clipboard = false,
    },
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
      ---@type AvantePosition
      position = "right",
      wrap = true,
      width = 40,
      input = {
        prefix = "> ",
        height = 15,
      },
      sidebar_header = { enabled = false },
      edit = { start_insert = true },
      ask = { start_insert = false },
    },
  },
}
