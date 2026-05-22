---@type LazyPluginSpec
return {
  "nvim-web-devicons",
  opts = function()
    local yaml_icon = { icon = "", color = "#D70000", cterm_color = "160" }

    return {
      override = {
        yaml = vim.tbl_extend("keep", yaml_icon, { name = "Yaml" }),
        yml = vim.tbl_extend("keep", yaml_icon, { name = "Yml" }),
      },
    }
  end,
}
