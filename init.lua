if vim.g.vscode then
  require("custom.vscode")
else
  require("custom.configs")
  require("config.lazy")
end
