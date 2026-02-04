
require("plugins.catppuccin")
require("plugins.markdown")
require("plugins.whichkey")
require("plugins.telescope")
require("plugins.netrw")
require("plugins.nvim-tree").setup()
require("plugins.nvim-tree").keymaps()
require("plugins.lualine")



vim.pack.add({
  "https://github.com/ojroques/vim-oscyank",
  "https://github.com/brenoprata10/nvim-highlight-colors",
}, { confirm = false })

-- OSC Yank
vim.keymap.set('n', '<leader>c', '<Plug>OSCYankOperator')
vim.keymap.set('n', '<leader>cc', '<leader>c_', { remap = true })
vim.keymap.set('v', '<leader>c', '<Plug>OSCYankVisual')

vim.g.oscyank_silent = 1
vim.g.oscyank_trim   = 1

-- Highlight Colors
vim.opt.termguicolors = true
require("nvim-highlight-colors").setup({
  render = "background",
})



