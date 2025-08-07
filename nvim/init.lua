-- Set leader key to ;
vim.g.mapleader = ';'

-- Don't use swap files
vim.opt.swapfile = false

--- No incremental search (only show search results after clicking enter)
vim.opt.incsearch = false;

-- zx centers the cursor 30 lines below the top. I use this sometimes on vertical monitors
vim.api.nvim_set_keymap('n', 'zx', 'zt30k', {})

-- " <Ctrl-j> Pretty formats curent buffer as JSON "
vim.api.nvim_set_keymap('n', '<C-j>', ':%!python -m json.tool<CR>', {})

-- Show tabs and trailing spaces
vim.opt.listchars = {
  trail = '·',
  tab = '→ ',
}
vim.opt.list = true

-- Spell checking
vim.opt.spell = false
vim.opt.spelllang = {'en_us'}
vim.api.nvim_create_autocmd(
  {
    'BufEnter',
    'BufWinEnter'
  },
  {
    pattern = {
      '*.md',
    },
    command = [[:setlocal spell]]
  }
)

-- Highlight current line
vim.opt.cursorline = true
vim.api.nvim_set_hl(
  0,
  'CursorLine',
  {
    bold = true,
    bg = '#333333',
    ctermbg = 235,
  }
)

-- Treat long lines as break lines (useful when moving around in them)
vim.api.nvim_set_keymap('n', 'j', 'gj', {})
vim.api.nvim_set_keymap('n', 'k', 'gk', {})

-- Disallow use of arrow keys to move. Use hjkl instead
vim.api.nvim_set_keymap('n', '<up>', '<nop>', {})
vim.api.nvim_set_keymap('n', '<down>', '<nop>', {})
vim.api.nvim_set_keymap('n', '<left>', '<nop>', {})
vim.api.nvim_set_keymap('n', '<right>', '<nop>', {})

-- Make y(y) and paste(p) operations use the system clipboard
vim.opt.clipboard = 'unnamedplus'

-- Shift+Tab unindents a line
vim.api.nvim_set_keymap('i', '<S-Tab>', '<Esc><<i', {})
vim.api.nvim_set_keymap('n', '<S-Tab>', '<<', {})

-- Visual mode tab/untab identation
vim.api.nvim_set_keymap('v', '<S-Tab>', '<gv', {})
vim.api.nvim_set_keymap('v', '<Tab>', '>gv', {})

-- Show all diagnostics for current line in pop up
vim.api.nvim_set_keymap( 'n', '<Leader>do', ':lua vim.diagnostic.open_float()<CR>', {})
vim.api.nvim_set_keymap( 'n', '<Leader>dn', ':lua vim.diagnostic.goto_next()<CR>', {})
vim.api.nvim_set_keymap( 'n', '<Leader>dp', ':lua vim.diagnostic.goto_prev()<CR>', {})

-- Replace tabs with spaces
vim.opt.expandtab = true
vim.opt.smarttab = true

-- Set tab size to 2
local TAB_WIDTH = 2
vim.opt.tabstop = TAB_WIDTH
vim.opt.shiftwidth = TAB_WIDTH

-- Set tab size to 4 spaces for Python
vim.api.nvim_create_autocmd("FileType", {
  pattern = "py",
  callback = function()
    local PY_TAB_WIDTH = 2
    vim.opt_local.shiftwidth = PY_TAB_WIDTH
    vim.opt_local.tabstop = PY_TAB_WIDTH
  end
})

-- " For Golang use tabs "
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.opt_local.expandtab = false
  end
})

-- Show line numbers
vim.opt.number = true

-- Highlight column 81
vim.opt.colorcolumn = '81'

-- Change spellcheck highlight to be easier to read
vim.api.nvim_set_hl(0, "SpellBad", {underdotted=true, bold=true, fg="#ff0000", ctermfg="red"})
vim.api.nvim_set_hl(0, "SpellCap", {underdotted=true, bold=true, fg="#ff0000", ctermfg="red"})
vim.api.nvim_set_hl(0, "SpellRare", {underdotted=true, bold=true, fg="#ff0000", ctermfg="red"})
vim.api.nvim_set_hl(0, "SpellLocal", {underdotted=true, bold=true, fg="#ff0000", ctermfg="red"})

-- Search case insensitive if term is all lowercase
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Setup lazy plugin manager
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup('plugins')
