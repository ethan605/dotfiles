---@type LazyPluginSpec
return {
  "numToStr/Comment.nvim",
  ---@type CommentConfig
  ---@diagnostic disable-next-line: missing-fields
  opts = {
    toggler = {
      line = "<Leader>c<Space>",
      block = "<Leader>cm",
    },
    opleader = {
      line = "<Leader>c<Space>",
      block = "<Leader>cm",
    },
    ---@diagnostic disable-next-line: missing-fields
    mappings = {
      extra = false,
    },
  },
}
