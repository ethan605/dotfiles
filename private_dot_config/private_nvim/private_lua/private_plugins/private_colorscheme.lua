---@type LazyPluginSpec
return {
  "connorholyday/vim-snazzy",
  priority = 1000,
  init = function() vim.cmd.colorscheme("snazzy") end,
}
