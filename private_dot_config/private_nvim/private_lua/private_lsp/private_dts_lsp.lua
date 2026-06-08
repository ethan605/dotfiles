---@type vim.lsp.Config
return {
  cmd = { "devicetree-language-server", "--stdio" },
  filetypes = { "dts", "dtsi" },
  root_markers = { ".zephyr", ".git", "." },
  settings = {
    devicetree = {
      autoChangeContext = true,
      allowAdhocContexts = true,
      cwd = "${workspaceFolder}",
      defaultBindingType = "Zephyr",
      defaultIncludePaths = {
        -- Zephyr SDK (SoC DTSIs, headers)
        ".zephyr-sdk/dts",
        ".zephyr-sdk/dts/arm",
        ".zephyr-sdk/dts/arm64",
        ".zephyr-sdk/dts/riscv",
        ".zephyr-sdk/dts/common",
        ".zephyr-sdk/include",
        -- ZMK app (behaviors, keymap includes)
        ".zmk-app/dts",
        ".zmk-app/include",
        -- Upstream corne shield (corne.dtsi)
        ".zmk-app/boards/shields/corne",
      },
      defaultShowFormattingErrorAsDiagnostics = false,
      defaultZephyrBindings = {
        ".zmk-app/dts/bindings",
        ".zephyr-sdk/dts/bindings",
      },
      contexts = {
        {
          ctxName = "dongle",
          dtsFile = ".zephyr-sdk/boards/arm/seeeduino_xiao_ble/seeeduino_xiao_ble.dts",
          overlays = {
            "config/boards/shields/corne_dongle/corne_dongle.overlay",
            "config/corne.keymap",
          },
        },
      },
    },
  },
}
