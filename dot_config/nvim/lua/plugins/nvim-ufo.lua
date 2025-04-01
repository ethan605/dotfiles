---@type LazySpec
return {
  "kevinhwang91/nvim-ufo",
  dependencies = { "kevinhwang91/promise-async" },
  ---@type UfoConfig
  opts = {
    open_fold_hl_timeout = 400,
    close_fold_kinds_for_ft = {},
    enable_get_fold_virt_text = false,
    preview = {
      win_config = {
        winblend = 1,
        winhighlight = "Normal:Normal,FloatBorder:FoldColumn",
      },
      mappings = {
        scrollU = "<C-u>",
        scrollD = "<C-d>",
        jumpTop = "[",
        jumpBot = "]",
      },
    },
  },
}
