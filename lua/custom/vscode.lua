local vscode = require("vscode")
local map = vim.keymap.set

vim.opt.clipboard = "unnamedplus"

map("x", "fq", function()
  vscode.action("cancelSelection")
end)

map("x", "fo", function()
  vscode.action("editor.action.openLink")
end)

-- "args": "<C-d>",
-- "command": "vscode-neovim.send",
-- "key": "ctrl+d",
-- "when": "editorFocus && neovim.init"
map("n", "<C-d>", "mciw*<Cmd>nohl<CR>", { remap = true })

