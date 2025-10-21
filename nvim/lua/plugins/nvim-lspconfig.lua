vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    -- Go to definition
    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', {buffer = event.buf})

    -- Return to previous location after going to definition
    vim.api.nvim_set_keymap('n', 'gb', '<C-t>', {})

    -- Go to definition in new tab
    vim.api.nvim_set_keymap('n', 'gdt', '<C-w><C-]><C-w>T', {})

    -- Code completion
    vim.api.nvim_set_keymap('i', '<C-Space>', '<C-x><C-o>', {})

    -- Don't open an empty buffer when triggering autocomplete
    vim.o.completeopt = 'menu'

    -- Show documentation for symbol
    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', {buffer = event.buf})

    -- Format code
    vim.keymap.set('n', 'F', '<cmd>lua vim.lsp.buf.format()<cr>', {buffer = event.buf})

    -- Rename symbol
    vim.keymap.set('n', '3r', '<cmd>lua vim.lsp.buf.rename()<cr>', {buffer = event.buf})
  end
})

return {
  'neovim/nvim-lspconfig',
  config = function()
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    vim.lsp.config('clangd', {})
    vim.lsp.enable({'clangd'})
    vim.lsp.config('arduino_language_server', {})
    vim.lsp.enable({'arduino_language_server'})
    vim.lsp.config('gopls', {})
    vim.lsp.enable({'gopls'})
    vim.lsp.config('graphql', {})
    vim.lsp.enable({'graphql'})
    vim.lsp.config('jdtls', {})
    vim.lsp.enable({'jdtls'})
    vim.lsp.config('lua_ls', {
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
    })
    vim.lsp.enable({'lua_ls'})
    vim.lsp.config('rust_analyzer', {})
    vim.lsp.enable({'rust_analyzer'})
    vim.lsp.config('svelte', {})
    vim.lsp.enable({'svelte'})
    vim.lsp.config('ts_ls', {})
    vim.lsp.enable({'ts_ls'})
  end
}
