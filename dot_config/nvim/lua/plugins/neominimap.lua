---@type LazySpec
return {
  "Isrothy/neominimap.nvim",
  version = "v3.x.x",
  lazy = false,
  init = function()
    ---@type Neominimap.UserConfig
    vim.g.neominimap = {
      auto_enable = false,
    }
  end,
  keys = {
    { "<leader>nm", ":Neominimap toggle<cr>",      desc = "Toggle global minimap" },
    { "<leader>ns", ":Neominimap toggleFocus<cr>", desc = "Switch focus on minimap" },
  },
}
