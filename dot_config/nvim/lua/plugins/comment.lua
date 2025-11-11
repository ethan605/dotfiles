---@type LazySpec
return {
  "numToStr/Comment.nvim",
  ---@diagnostic disable: missing-fields
  ---@type CommentConfig
  opts = {
    toggler = {
      line = "<Leader>c<Space>",
      block = "<Leader>cm",
    },
    opleader = {
      line = "<Leader>c<Space>",
      block = "<Leader>cm",
    },
    mappings = {
      extra = false,
    },
  },
  ---@diagnostic enable: missing-fields
}
