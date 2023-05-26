local function open_nvim_tree()
  require("nvim-tree.api").tree.open()
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("nvim-tree").setup({
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
        local openTreeGrp = vim.api.nvim_create_augroup("AutoOpenTree", { clear = true })
        vim.api.nvim_create_autocmd("TabNew", {
          command = "NvimTreeFindFile",
          group = openTreeGrp,
        })

        -- Closes nvim-tree if it's the last open buffer
        vim.o.confirm = true
        vim.api.nvim_create_autocmd("BufEnter", {
          group = vim.api.nvim_create_augroup("NvimTreeClose", {clear = true}),
          callback = function()
            local layout = vim.api.nvim_call_function("winlayout", {})
            if layout[1] == "leaf" and
                vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(layout[2]), "filetype") == "NvimTree"
                and layout[3] == nil then
              vim.cmd("quit")
            end
          end
        })

        -- Open file in new tab or focus existing buffer if it already exists
        -- When we open a file in a new tab, the old window title stays as nvim-tree.lua
        -- because that was the last buffer for that tab. This fixes it by adding
        -- a Ctrl + T keymap
        local swap_then_open_tab = function()
          local node = api.tree.get_node_under_cursor()
          if node.type == 'file' then
            vim.cmd("wincmd l")
          end
          api.node.open.tab(node)
        end
        vim.keymap.set("n", "<CR>", swap_then_open_tab, opts("Tab drop"))
      end
    })
  end,
}
