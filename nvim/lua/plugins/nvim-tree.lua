local function open_nvim_tree()
  require("nvim-tree.api").tree.open()
end

vim.api.nvim_create_autocmd({ 'VimEnter' }, { callback = open_nvim_tree })

return {
  'nvim-tree/nvim-tree.lua',
  version = '*',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('nvim-tree').setup({
      actions = {
        remove_file = {
          close_window = true,
        },
      },
      on_attach = function(bufnr)
        local api = require('nvim-tree.api')

        local function opts(desc)
          return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        -- This part removes f and F mappings which conflict with telescope
        api.config.mappings.default_on_attach(bufnr)
        vim.keymap.del('n', 'f', { buffer = bufnr })
        vim.keymap.del('n', 'F', { buffer = bufnr })

        -- Opens nvim-tree when a new tab is created
        vim.api.nvim_create_autocmd('WinNew', {
          callback = function()
            vim.defer_fn(function()
              local has_tree = false
              for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
                if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == 'NvimTree' then
                  has_tree = true
                  break
                end
              end
              if not has_tree then
                require('nvim-tree.api').tree.open()
                -- Switch focus to the other window
                for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
                  if win ~= vim.api.nvim_get_current_win() then
                    vim.api.nvim_set_current_win(win)
                    break
                  end
                end
              end
            end, 10)
          end,
        })

        vim.api.nvim_create_autocmd('WinClosed', {
          callback = function()
            vim.defer_fn(function()
              local wins = vim.api.nvim_tabpage_list_wins(0)
              if #wins == 1 then
                local buf = vim.api.nvim_win_get_buf(wins[1])
                if vim.bo[buf].filetype == 'NvimTree' then
                  vim.cmd('quit')
                end
              end
            end, 10)
          end,
        })

        -- Open file in new tab or focus existing buffer if it already exists
        -- When we open a file in a new tab, the old window title stays as nvim-tree.lua
        -- because that was the last buffer for that tab. This fixes it by adding
        -- a Ctrl + T keymap
        local swap_then_open_tab = function()
          local node = api.tree.get_node_under_cursor()
          if node.type == 'file' then
            -- Switch to right buffer
            vim.cmd('wincmd l')
          end
          api.node.open.tab_drop(node)
        end
        vim.keymap.set('n', '<CR>', swap_then_open_tab, opts('Tab drop'))
      end
    })
  end,
}
