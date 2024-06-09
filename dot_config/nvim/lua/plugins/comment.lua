return {
  "numToStr/Comment.nvim",
  config = function()
    require("Comment").setup({
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
    })
  end,
}
