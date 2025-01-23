if vim.g.vscode then
    -- VSCode extension
else
    -- ordinary Neovim
end

-- [basic config]

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.o.number = true
vim.o.relativenumber = true

vim.o.scrolloff = 10
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.cursorline = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- [keymap] 


-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")




