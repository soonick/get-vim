return {
  'CopilotC-Nvim/CopilotChat.nvim',
  dependencies = {
    { 'github/copilot.vim' },
    { 'nvim-lua/plenary.nvim' },
  },
  opts = {
    window = {
      layout = 'float',
    },
  },
  cmd = {
    'CopilotChat', 'CopilotChatOpen', 'CopilotChatClose', 'CopilotChatToggle'
  },
  keys = {
    { '<leader>cc', ':CopilotChatToggle<CR>', desc = 'Toggle Copilot Chat' },
  },
}
