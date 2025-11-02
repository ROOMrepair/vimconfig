return {
  {
    "folke/snacks.nvim",
    opts = {},
    keys = {
      {
        "gS",
        function()
          require("snacks").scope.jump()
        end,
        desc = "jump to parent scope",
      },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" }, -- if you use the mini.nvim suite
    opts = {},
  },
}
