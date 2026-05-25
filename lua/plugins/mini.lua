return {
  {
    "nvim-mini/mini.nvim",
    version = false,
    opt = {},
    config = function()
      require("mini.align").setup()
    end,
  },
}
