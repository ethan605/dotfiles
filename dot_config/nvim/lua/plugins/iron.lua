---@type LazySpec
return {
  "Vigemus/iron.nvim",
  config = function()
    local iron = require("iron.core")
    local common = require("iron.fts.common")

    iron.setup({
      config = {
        scratch_repl = true,
        repl_definition = {
          python = common.ipython,
        },
        repl_open_cmd = "vertical botright split",
      },
      keymaps = {
        visual_send = "<leader>rc",
        send_line = "<leader>rc",
        exit = "<leader>rq",
        clear = "<leader>rx",
      },
      highlight = {
        italic = true,
      },
      ignore_blank_lines = true,
    })
  end,
}
