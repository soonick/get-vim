return {
  'nvim-telescope/telescope.nvim', tag = '0.1.1',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-fzf-native.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  config = function()
    local telescope = require('telescope')
    local actions = require('telescope.actions')
    local builtin = require('telescope.builtin')

    -- Open files in new tab or focus on the tab if already open
    telescope.setup({
      defaults = {
        mappings = {
          i = {
            ['<CR>'] = function(bufnr)
              require('telescope.actions.set').edit(bufnr, 'tab drop')
            end,
          }
        },
        file_ignore_patterns = {
          'node_modules'
        }
      }
    })

    -- ff to find files, fg to grep in files
    vim.keymap.set('n', 'ff', builtin.find_files, {})
    vim.keymap.set('n', 'fg', builtin.live_grep, {})

    -- Grep for word under cursor
    local function grep_word_under_cursor()
      local query = vim.fn.expand('<cword>')
      if query ~= '' then
        builtin.grep_string({
          search = query,
        })
      end
    end

    -- Map a key to trigger grep for word under cursor
    vim.keymap.set('n', '<leader>g', grep_word_under_cursor, { noremap = true, silent = true })
  end
}
