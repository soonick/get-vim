return {
  'cappyzawa/trim.nvim',
  dependencies = {},
  config = function()
    require('trim').setup({
      trim_on_write = true,
      trim_trailing = true,
      trim_last_line = true,
      trim_first_line = true,
      ft_blocklist = {'markdown'},
    })
  end
}
