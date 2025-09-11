---@type LazySpec
return {
  "A7Lavinraj/fyler.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  branch = "main",
  ---type FylerConfig
  opts = {
    icon_provider = "nvim_web_devicons",
    -- icon = {
    --   directory_collapsed = nil,
    --   directory_empty = nil,
    --   directory_expanded = nil,
    -- },
    hooks = {},
    mappings = {
      ["q"] = "CloseView",
      ["<CR>"] = "Select",
      ["^"] = "GotoParent",
      ["."] = "GotoCwd",
    },
    close_on_select = true,
    confirm_simple = false,
    default_explorer = true,
    git_status = {
      enabled = false,
      -- symbols = {
      --   Untracked = "●",
      --   Added = "✚",
      --   Modified = "●",
      --   Deleted = "✖",
      --   Renamed = "➜",
      --   Copied = "C",
      --   Conflict = "‼",
      --   Ignored = "○",
      -- },
    },
    indentscope = {
      enabled = true,
      -- group = "FylerIndentMarker",
      -- marker = "│",
    },
    track_current_buffer = true,
    win = {
      kind_presets = {
        replace = {},
      },
      kind = "replace",
      -- border = "single",
      -- buf_opts = {
      --   filetype = "fyler",
      --   syntax = "fyler",
      --   buflisted = false,
      --   buftype = "acwrite",
      --   expandtab = true,
      --   shiftwidth = 2,
      -- },
      -- win_opts = {
      --   concealcursor = "nvic",
      --   conceallevel = 3,
      --   cursorline = true,
      --   number = true,
      --   relativenumber = true,
      --   winhighlight = "Normal:Normal,FloatBorder:FloatBorder,FloatTitle:FloatTitle",
      --   wrap = false,
      -- },
    },
  },
}
