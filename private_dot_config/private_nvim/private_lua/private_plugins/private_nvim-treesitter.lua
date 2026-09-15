---@type LazyPluginSpec
return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
  config = function()
    local treesitter = require("nvim-treesitter")

    treesitter.setup({
      install_dir = vim.fn.stdpath("data") .. "/site",
    })

    treesitter.install({
      "bash",
      "cmake",
      "comment",
      "cpp",
      "devicetree",
      "go",
      "gosum",
      "java",
      "javascript",
      "json",
      "json5",
      "jsonnet",
      "jsx",
      "kconfig",
      "make",
      "nix",
      "python",
      "rust",
      "scala",
      "terraform",
      "tsx",
      "typescript",
      "yaml",
      "zsh",
    })

    local textobjects = require("nvim-treesitter-textobjects")
    textobjects.setup({
      select = {
        lookahead = true, -- jump forward to the next textobject, like targets.vim
        selection_modes = { ["@function.outer"] = "V" },
      },
      move = { set_jumps = true },
    })

    local select = require("nvim-treesitter-textobjects.select")
    local move = require("nvim-treesitter-textobjects.move")
    local swap = require("nvim-treesitter-textobjects.swap")

    local function sel(key, query, desc)
      vim.keymap.set(
        { "x", "o" }, key,
        function() select.select_textobject(query, "textobjects") end,
        { desc = desc }
      )
    end
    local function goto_(key, fn, query, desc)
      vim.keymap.set({ "n", "x", "o" }, key, function()
        move[fn](query, "textobjects")
      end, { desc = desc })
    end

    -- Select: function / class / parameter
    -- (csv/tsv buffers intentionally keep csvview's if/af field textobjects)
    sel("af", "@function.outer", "Around function")
    sel("if", "@function.inner", "Inside function")
    sel("ac", "@class.outer", "Around class")
    sel("ic", "@class.inner", "Inside class")
    sel("aa", "@parameter.outer", "Around argument")
    sel("ia", "@parameter.inner", "Inside argument")

    -- Move: function starts/ends
    -- (python/java ftplugins have buffer-local [m/]m that shadow these in those buffers)
    goto_("]m", "goto_next_start", "@function.outer", "Next function start")
    goto_("[m", "goto_previous_start", "@function.outer", "Previous function start")
    goto_("]M", "goto_next_end", "@function.outer", "Next function end")
    goto_("[M", "goto_previous_end", "@function.outer", "Previous function end")

    -- Swap function arguments
    vim.keymap.set(
      "n", "<Leader>a",
      function() swap.swap_next("@parameter.inner") end,
      { desc = "Swap argument with next" }
    )
    vim.keymap.set(
      "n", "<Leader>A",
      function() swap.swap_previous("@parameter.inner") end,
      { desc = "Swap argument with previous" }
    )
  end,
}
