return {
  "akinsho/bufferline.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  version = "*",
  event = "VeryLazy",
  opts = {
    options = {
      always_show_bufferline = true,
      mode = "tabs",
      separator_style = "slant",
      show_buffer_icons = true,
      show_buffer_close_icons = true,
      show_close_icon = true,
      show_tab_indicators = true,
      diagnostics = "nvim_lsp",
      offsets = {
        {
          filetype = "NvimTree",
          text = "",
          padding = 1,
        },
      },
    },
  },
}
