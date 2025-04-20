---@type LazySpec
return {
  "connorholyday/vim-snazzy",
  init = function() vim.cmd.colorscheme("snazzy") end,
}

---@type LazySpec
-- return {
--   "Martinits/nvim-snazzi",
--   dependencies = { "rktjmp/lush.nvim" },
--   init = function() vim.cmd.colorscheme("snazzi") end,
-- }
