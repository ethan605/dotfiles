---@type LazyPluginSpec
return {
  "rest-nvim/rest.nvim",
  ft = "http",
  build = false,
  dependencies = {
    "j-hui/fidget.nvim",
    "lunarmodules/lua-mimetypes",
    "nvim-neotest/nvim-nio",
    "nvim-treesitter/nvim-treesitter",
    {
      "manoelcampos/xml2lua",
      config = function(plugin)
        -- Lazy.nvim does not recognize this library's rocksfile,
        -- so add it to package path manually
        package.path = package.path .. ";" .. plugin.dir .. "/?.lua"
      end,
    },
  },
  config = function()
    ---@class rest.Config
    -- vim.g.rest_nvim = {}

    -- Pretty-print JSON with `gq`. rest.nvim formats responses in a scratch buffer,
    -- so the option must be set per filetype, not on the current buffer.
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "json" },
      callback = function()
        vim.bo.formatexpr = ""
        vim.bo.formatprg = "jq"
      end,
    })
  end,
  keys = {
    { "<leader>rr", ":Rest run<CR>",        { desc = "Run rest command" } },
    { "<leader>re", ":Rest env select<CR>", { desc = "Select rest env" } },
    { "<leader>rl", ":Rest run last<CR>",   { desc = "Run last rest command" } },
  },
}
