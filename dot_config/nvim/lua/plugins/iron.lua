---@type LazySpec
return {
  "Vigemus/iron.nvim",
  config = function()
    local iron = require("iron.core")
    local fts = require("iron.fts")

    iron.setup({
      config = {
        scratch_repl = true,
        repl_definition = {
          python = vim.tbl_extend("force", fts.python.ipython, { block_dividers = { "# %%", "#%%" } }),
          typescript = vim.tbl_extend(
            "force",
            fts.typescript.ts,
            { command = { "ts-node", "-O", '{"module": "commonjs"}' } }
          ),
        },
        repl_open_cmd = "vertical botright split",
      },
      keymaps = {
        visual_send = "<leader>rc",
        send_line = "<leader>rc",
        interrupt = "<leader>rs",
      },
      highlight = {
        italic = true,
      },
      ignore_blank_lines = true,
    })
  end,
}
