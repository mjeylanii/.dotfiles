return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPre", "BufNewFile" },
  build = ":TSUpdate",
  dependencies = {
    "windwp/nvim-ts-autotag",
  },
  config = function()
    local configs = require("nvim-treesitter.configs")

    configs.setup({
      ensure_installed = {
        "bash",
        "c",
        "cpp",
        "dart",
        "dockerfile",
        "gitignore",
        "go",
        "graphql",
        "html",
        "java",
        "javascript",
        "json",
        "kotlin",
        "lua",
        "markdown",
        "python",
        "query",
        "regex",
        "rust",
        "toml",
        "tsx",
        "typescript",
        "yaml",
      },
      auto_install = true,
      sync_install = true,
      highlight = {
        enable = true,
        use_languagetree = true,
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
      indent = {
        enable = true,
      },
    })
  end,
}
