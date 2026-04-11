---@type LazyPluginSpec
return {
  "connorholyday/vim-snazzy",
  priority = 1000,
  enabled = true,
  init = function() vim.cmd.colorscheme("snazzy") end,
}
