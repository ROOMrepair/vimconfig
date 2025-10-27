return {
  dir = "C:/Users/25399/AppData/Local/nvim/lua/custom",
  "loka/colcoms.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("custom.colcoms2").start()
  end,
}
