---@type LazySpec
return {
  "connorholyday/vim-snazzy",
  -- TODO: Revise this
  -- "alexwu/nvim-snazzy",
  -- dependencies = { "rktjmp/lush.nvim" },
  config = function() vim.cmd.colorscheme("snazzy") end,
}
