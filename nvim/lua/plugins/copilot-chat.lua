return {
  'CopilotC-Nvim/CopilotChat.nvim',
  dependencies = {
    { 'github/copilot.vim' }, -- required for autocompletion
    { 'nvim-lua/plenary.nvim' }, -- required by CopilotChat
  },
  opts = {
    -- You can customize prompts, UI behavior, etc.
  },
  cmd = {
    'CopilotChat', 'CopilotChatOpen', 'CopilotChatClose', 'CopilotChatToggle'
  },
  keys = {
    { '<leader>cc', ':CopilotChatToggle<CR>', desc = 'Toggle Copilot Chat' },
  },
}
