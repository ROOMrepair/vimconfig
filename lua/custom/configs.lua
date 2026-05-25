vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

--  theme
vim.o.bg = "dark"
vim.g.moonflyTransparent = true

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

vim.keymap.set("i", "jj", "<Esc>", { noremap = true })
vim.keymap.set("n", "gm", "<CMD>messages<CR>", { desc = "open message" })

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.json",
  callback = function()
    vim.cmd([[%!jq .]])
  end,
})

vim.api.nvim_create_autocmd("ExitPre", {
  pattern = "*",
  callback = function(event)
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_get_option(buf, "buftype") == "terminal" then
        vim.api.nvim_buf_delete(buf, { force = true })
      end
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*.ps1",
  callback = function()
    vim.b.completion = false
  end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    -- 取消一部分高亮
    vim.api.nvim_set_hl(0, "StatusLine", { bg = "none" })
    vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "none" })
    vim.api.nvim_set_hl(0, "WinSeparator", { bg = "none", fg = "#2e2e2e" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    vim.api.nvim_set_hl(0, "StatusLineTerm", { bg = "none" })
    vim.api.nvim_set_hl(0, "StatusLineTermNC", { bg = "none" })
    vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("mylsp", {}),
  callback = function(args)
    local map = vim.keymap.set
    map("n", "gL", vim.diagnostic.setloclist, { desc = "show local diagnostic" })
  end,
})
