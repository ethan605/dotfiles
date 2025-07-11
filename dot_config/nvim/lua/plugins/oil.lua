local function parse_output(proc)
  local result = proc:wait()
  local ret = {}
  if result.code == 0 then
    for line in vim.gsplit(result.stdout, "\n", { plain = true, trimempty = true }) do
      -- Remove trailing slash
      line = line:gsub("/$", "")
      ret[line] = true
    end
  end
  return ret
end

-- build git status cache
local function new_git_status()
  return setmetatable({}, {
    __index = function(self, key)
      local ignore_proc = vim.system(
        { "git", "ls-files", "--ignored", "--exclude-standard", "--others", "--directory" },
        {
          cwd = key,
          text = true,
        }
      )
      local tracked_proc = vim.system({ "git", "ls-tree", "HEAD", "--name-only" }, {
        cwd = key,
        text = true,
      })
      local ret = {
        ignored = parse_output(ignore_proc),
        tracked = parse_output(tracked_proc),
      }

      rawset(self, key, ret)
      return ret
    end,
  })
end

---@type LazySpec
return {
  "stevearc/oil.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "refractalize/oil-git-status.nvim",
  },
  config = function()
    local git_status = new_git_status()
    local showing_detail_view = false
    local sorting_by_size_asc = true

    -- Clear git status cache on refresh
    local refresh = require("oil.actions").refresh
    local orig_refresh = refresh.callback
    refresh.callback = function(...)
      git_status = new_git_status()
      orig_refresh(...)
    end

    local oil = require("oil")

    ---type oil.Config
    local opts = {
      default_file_explorer = false,
      delete_to_trash = true,
      view_options = {
        is_hidden_file = function(name, bufnr)
          local dir = oil.get_current_dir(bufnr)
          local is_dotfile = vim.startswith(name, ".") and name ~= "../"
          -- If no local directory (e.g. for ssh connections), just hide dotfiles
          if not dir then return is_dotfile end
          -- Dotfiles are considered hidden unless tracked
          if is_dotfile then
            return not git_status[dir].tracked[name]
          else
            -- Check if file is gitignored
            return git_status[dir].ignored[name]
          end
        end,
      },
      win_options = {
        signcolumn = "yes:2",
      },
      keymaps = {
        ["g?"] = { "actions.show_help", mode = "n" },
        ["g]"] = "actions.select",
        ["g["] = { "actions.parent", mode = "n" },
        ["gp"] = "actions.preview",
        ["gC"] = { "actions.close", mode = "n" },
        ["gr"] = "actions.refresh",
        ["gy"] = "actions.yank_entry",
        ["g~"] = { "actions.open_cwd", mode = "n" },
        ["g."] = { "actions.toggle_hidden", mode = "n" },
        ["g\\"] = { "actions.toggle_trash", mode = "n" },
        ["gd"] = {
          desc = "Toggle file detail view",
          callback = function()
            showing_detail_view = not showing_detail_view
            if showing_detail_view then
              oil.set_columns({
                "icon",
                { "permissions", highlight = "Keyword" },
                { "size",        highlight = "Special" },
                { "mtime",       highlight = "Comment" },
              })
            else
              oil.set_columns({ "icon" })
            end
          end,
        },
        ["gS"] = {
          desc = "Toggle sorting by size",
          callback = function()
            sorting_by_size_asc = not sorting_by_size_asc
            if sorting_by_size_asc then
              oil.set_sort({ { "size", "asc" } })
            else
              oil.set_sort({ { "size", "desc" } })
            end
          end,
        },
      },
      keymaps_help = {
        border = "solid",
      },
      use_default_keymaps = false,
    }

    oil.setup(opts)
  end,
}
