local vscode = require('vscode')

local map = vim.keymap.set

vim.opt.clipboard = "unnamedplus"

map("n", ",j", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map("n", ",k", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map("v", ",j", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map("v", ",k", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })
map("i", ",j", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", ",k", "<esc><cmd>m .-1<cr>==gi", { desc = "Move Up" })

-- map({ "n", "x", "i" }, "fi", function()
--   vscode.with_insert(function()
--     vscode.action("editor.action.addSelectionToNextFindMatch")
--   end)
-- end)

map("x","fq",function()
  vscode.action("cancelSelection")
end)

map("x","fo",function()
  vscode.action("editor.action.openLink")
end)