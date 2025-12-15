---@type LazySpec
return {
  "kevinhwang91/nvim-ufo",
  dependencies = { "kevinhwang91/promise-async" },
  keys = {
    { "zk", function() require("ufo").peekFoldedLinesUnderCursor() end, desc = "UFO peek" },
    -- { "zR", function() require("ufo").openAllFolds() end,               desc = "UFO open all folds" },
    -- { "zr", function() require("ufo").openFoldsExceptKinds() end,       desc = "UFO open folds" },
    -- { "zM", function() require("ufo").closeAllFolds() end,              desc = "UFO close all folds" },
    -- { "zm", function() require("ufo").closeFoldsWith() end,             desc = "UFO close folds" },
  },
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
