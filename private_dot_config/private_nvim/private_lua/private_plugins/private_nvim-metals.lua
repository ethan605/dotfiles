---@type LazyPluginSpec
return {
  "scalameta/nvim-metals",
  ft = { "scala", "sbt" },
  opts = function()
    local metals_config = require("metals").bare_config()
    local lsp_commons = require("lsp.common")

    return vim.tbl_extend(
      "force",
      metals_config,
      {
        -- TODO: revisit https://github.com/scalameta/nvim-metals/issues/762
        init_options = { globSyntax = "vscode" },
        capabilities = lsp_commons.capabilities,
        on_attach = lsp_commons.on_attach,
      }
    )
  end,
  config = function(self, metals_config)
    local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      pattern = self.ft,
      callback = function()
        require("metals").initialize_or_attach(metals_config)
      end,
      group = nvim_metals_group,
    })
  end,
}
