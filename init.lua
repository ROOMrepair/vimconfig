vim.g.mapleader = " "
vim.g.maplocalleader = " "

--  theme
vim.o.bg = "light"
vim.g.moonflyTransparent = true
vim.g.moonflyWinSeparator = 2

-- vim.opt.shell = "cmd"
vim.opt.shell = "pwsh" -- 或 "powershell"
vim.opt.shellcmdflag = "-NoProfile -ExecutionPolicy RemoteSigned -Command"
vim.opt.shellquote = "" -- 非空会导致路径加多余引号
vim.opt.shellxquote = "" -- 非空会导致路径加多余引号

vim.opt.number = true
vim.opt.list = true
vim.opt.relativenumber = true
vim.opt.listchars = { tab = "| ", trail = "·", nbsp = " " }

vim.opt.scrolloff = 10
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.cursorline = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.lsp.config("luals", {})
vim.lsp.enable({ "clangd", "luals" })

-- [vscode]
if vim.g.vscode then
  -- VSCode extension
  require("custom.vscode")
  vim.g.minipairs_disable = true
  vim.b.minipairs_disable = true
else
end
-- ordinary Neovim
-- [[bootstrap lazy.nvim, LazyVim and your plugins]]
require("config.lazy")
