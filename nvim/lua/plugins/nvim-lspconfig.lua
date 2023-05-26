return {
  "neovim/nvim-lspconfig",
  config = function()
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    require('lspconfig').lua_ls.setup {
      capabilities = capabilities,
      settings = {
        Lua = {
          diagnostics = {
            globals = {
              'vim'
            }
          }
        }
      }
    }
    require('lspconfig').jdtls.setup {}
    require('lspconfig').gopls.setup {}
    require('lspconfig').graphql.setup {}
  end
}
