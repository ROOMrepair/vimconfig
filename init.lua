-- [basic config]

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.scrolloff = 10
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.cursorline = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- [vscode]
if vim.g.vscode then
  -- VSCode extension
  require("custom.vscode")
  vim.g.minipairs_disable = true
  vim.b.minipairs_disable = true
else
  -- ordinary Neovim
end

-- [[bootstrap lazy.nvim, LazyVim and your plugins]]

require("config.lazy")