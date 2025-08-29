---@type LazySpec
return {
  "A7Lavinraj/fyler.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  branch = "main",
  opts = function()
    local algos = require("fyler.views.explorer.algos")
    local store = require("fyler.views.explorer.store")

    ---@type FylerConfig
    return {
      icon_provider = "nvim-web-devicons",
      mappings = {
        ---@type table<string, function|FylerConfigMappingsExplorer>
        explorer = {
          ["q"] = "CloseView",
          ["<CR>"] = "Select",
          ["l"] = function(view)
            local itemid = algos.match_itemid(vim.api.nvim_get_current_line())
            if not itemid then return end

            local entry = store.get_entry(itemid)
            if not entry:is_dir() then return end

            view.root:find(itemid):toggle()
            vim.api.nvim_exec_autocmds("User", { pattern = "RefreshView" })
          end,
          ["^"] = "GotoParent",
          ["."] = "GotoCwd",
        },
        confirm = {
          ["y"] = "Confirm",
          ["n"] = "Discard",
        },
      },
      views = {
        explorer = {
          close_on_select = true,
          confirm_simple = false,
          default_explorer = true,
          git_status = true,
          indentscope = {
            enabled = true,
            group = "FylerIndentMarker",
            marker = "│",
          },
          win = {
            border = "single",
            kind_presets = {
              replace = {},
            },
            kind = "replace",
            buf_opts = {},
            win_opts = {},
          },
        },
        confirm = {
          win = {
            border = "single",
            kind_presets = {
              float = {
                height = "0.3rel",
                width = "0.4rel",
                top = "0.3rel",
                left = "0.3rel",
              },
            },
            kind = "float",
            buf_opts = {},
            win_opts = {},
          },
        },
      },
    }
  end,
}
