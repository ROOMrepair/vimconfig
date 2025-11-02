vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

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
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.cursorline = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.laststatus = 3

vim.lsp.config("luals", {})
vim.lsp.enable({ "clangd", "luals", "ts_ls" })
