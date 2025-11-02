return {
  "loka/colcoms.nvim",
  dir = "C:/Users/25399/AppData/Local/nvim/lua/custom",
  name = "color comment",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("custom.colcoms").start()
  end,
}
