return {
  "williamboman/mason-lspconfig.nvim",
  dependencies = {
    'williamboman/mason.nvim',
  },
  config = function()
    require("mason-lspconfig").setup({
      ensure_installed = {
        'gopls',
        'jdtls',
        'lua_ls',
        'graphql',
      }
    })
  end
}
