function _G.get_oil_winbar()
  local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
  local dir = require("oil").get_current_dir(bufnr)

  if dir then
    return vim.fn.fnamemodify(dir, ":~")
  else
    -- If there is no current directory (e.g. over ssh), just show the buffer name
    return vim.api.nvim_buf_get_name(0)
  end
end

return {
  "stevearc/oil.nvim",
  opts = {
    default_file_explorer = false,
    columns = { "icon", "permissions", "mtime" },
    win_options = {
      signcolumn = "yes:2",
      winbar = "%!v:lua.get_oil_winbar()",
    },
    keymaps = {
      ["g?"] = { "actions.show_help", mode = "n" },
      ["<CR>"] = "actions.select",
      ["go"] = { "actions.select" },
      ["gp"] = "actions.preview",
      ["gC"] = { "actions.close", mode = "n" },
      ["gr"] = "actions.refresh",
      ["<BS>"] = { "actions.parent", mode = "n" },
      ["g~"] = { "actions.open_cwd", mode = "n" },
      ["gS"] = { "actions.change_sort", mode = "n" },
      ["g."] = { "actions.toggle_hidden", mode = "n" },
      ["g\\"] = { "actions.toggle_trash", mode = "n" },
    },
    use_default_keymaps = false,
  },
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "refractalize/oil-git-status.nvim",
  },
}
