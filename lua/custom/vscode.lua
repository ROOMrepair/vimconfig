local vscode = require('vscode')

local map = vim.keymap.set

vim.opt.clipboard = "unnamedplus"

map("n", ",j", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map("n", ",k", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map("v", ",j", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map("v", ",k", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })
map("i", ",j", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", ",k", "<esc><cmd>m .-1<cr>==gi", { desc = "Move Up" })


map("x","fq",function()
  vscode.action("cancelSelection")
end)

map("x","fo",function()
  vscode.action("editor.action.openLink")
end)

-- vscode-neovim.ctrl+d
-- 这是一个 VS Code 内建命令，
-- 直接模拟 Neovim 的 <C-d> 默认行为（向下翻半页）
-- 这个命令绕过了 Neovim 的映射系统，不会去触发你自己写的 <C-d> 映射

-- 而 vscode-neovim.send + args: "<C-d>"
-- “我手动告诉 VS Code：当我按 Ctrl+D 时，把 <C-d> 字符字面量送进 Neovim 里，让它处理
map("n", "<C-d>", "mciw*<Cmd>nohl<CR>", { remap = true })

