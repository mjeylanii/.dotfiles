return {
  "neovim/nvim-lspconfig",
  config = function()
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    local lspconfig = require("lspconfig")

    lspconfig.tsserver.setup({
      capabilities = capabilities,
    })

    lspconfig.tailwindcss.setup({
      capabilities = capabilities,
    })

    lspconfig.cssls.setup({
      capabilities = capabilities,
    })

    lspconfig.html.setup({
      capabilities = capabilities,
    })

    lspconfig.jsonls.setup({
      capabilities = capabilities,
    })

    lspconfig.yamlls.setup({
      capabilities = capabilities,
    })

    lspconfig.dockerls.setup({
      capabilities = capabilities,
    })

    lspconfig.graphql.setup({
      capabilities = capabilities,
    })

    lspconfig.pyright.setup({
      capabilities = capabilities,
    })

    lspconfig.rust_analyzer.setup({
      capabilities = capabilities,
    })

    lspconfig.lua_ls.setup({
      capabilities = capabilities,
    })

    vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
    vim.keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, {})
    vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
    vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, {})
    vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
    vim.keymap.set("n", "<leader>gt", vim.lsp.buf.type_definition, {})
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
    vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, {})
  end,
}
