-- To debug
-- require("lspconfig").jdtls.setup({})

return {
  cmd = {
    vim.fn.expand("~/.asdf/shims/java"),
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dosgi.checkConfiguration=true",
    "-Dosgi.sharedConfiguration.area=" .. vim.fn.expand("~/.local/share/nvim/mason/share/jdtls/config"),
    "-Dosgi.sharedConfiguration.area.readOnly=true",
    "-Dosgi.configuration.cascaded=true",
    "-Xms1G",
    "--add-modules=ALL-SYSTEM",
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",
    "-javaagent:" .. vim.fn.expand("~/.local/share/nvim/mason/share/lombok-nightly/lombok.jar"),
    "-jar",
    vim.fn.expand("~/.local/share/nvim/mason/share/jdtls/plugins/org.eclipse.equinox.launcher.jar"),
    "-configuration",
    vim.fn.expand("~/.cache/nvim/jdtls/config"),
    "-data",
    vim.fn.expand("~/.cache/nvim/jdtls/workspaces/_Users_encord_Downloads_encord_be_challenge"),
  },
  filetypes = { "java" },
}
