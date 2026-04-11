---@type LazyPluginSpec
return {
  "connorholyday/vim-snazzy",
  priority = 1000,
  init = function() vim.cmd.colorscheme("snazzy") end,
}

--@type LazyPluginSpec
-- return {
--   "RRethy/nvim-base16",
--   priority = 1000,
--   config = function()
--     vim.cmd.colorscheme("base16-snazzy")
--   end,
-- }
