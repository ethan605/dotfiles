---@type LazySpec
return {
  "numToStr/Comment.nvim",
  ---@diagnostic disable: missing-fields
  ---@type CommentConfig
  opts = {
    toggler = {
      line = "<leader>c<space>",
      block = "<leader>cm",
    },
    opleader = {
      line = "<leader>c<space>",
      block = "<leader>cm",
    },
    mappings = {
      extra = false,
    },
  },
  ---@diagnostic enable: missing-fields
}
