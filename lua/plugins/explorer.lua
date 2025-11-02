return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = false,
  },
  {
    "stevearc/oil.nvim",
    lazy = false,
    opts = {},
    keys = {
      { "-", "<CMD>Oil<CR>", desc = "open parent directory" },
      { "_", "<CMD>Oil .<CR>", desc = "open cwd" },
    },
    dependencies = { { "nvim-mini/mini.icons", opts = {} } },
  },
}
