---@type LazySpec
return {
  "liuchengxu/vista.vim",
  dependencies = { "junegunn/fzf" },
  lazy = false,
  keys = {
    { "<leader>v", ":Vista finder<CR>" },
    { "<leader>V", ":Vista!!<CR>" },
  },
}
