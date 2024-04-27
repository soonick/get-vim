return {
  "williamboman/mason-lspconfig.nvim",
  dependencies = {
    'williamboman/mason.nvim',
  },
  config = function()
    require("mason-lspconfig").setup({
      ensure_installed = {
        'arduino_language_server',
        -- We need to install clangd for arduino_language_server to work
        'clangd',
        'gopls',
        'graphql',
        'jdtls',
        'lua_ls',
        'rust_analyzer'
      }
    })
  end
}
