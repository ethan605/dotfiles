return {
  "Bekaboo/dropbar.nvim",
  dependencies = {
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build =
      "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
    },
  },
  opts = {
    sources = {
      path = {
        relative_to = function(_)
          local fullpath = vim.api.nvim_buf_get_name(0)
          local filename = vim.fn.fnamemodify(fullpath, ":t")
          return fullpath:sub(0, #fullpath - #filename)
        end,
      },
    },
  },
}
