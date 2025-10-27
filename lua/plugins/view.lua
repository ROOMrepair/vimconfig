if vim.g.vscode then
  return {}
else
  return {
    {
      "nvim-neo-tree/neo-tree.nvim",
      enabled = false,
    },
    {
      "stevearc/oil.nvim",
      opts = {},
      -- Optional dependencies
      dependencies = { { "nvim-mini/mini.icons", opts = {} } },
      -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
      -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
      config = function()
        require("oil").setup()
        vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "open parent directory" })
        vim.keymap.set("n", "_", "<CMD>Oil .<CR>", { desc = "open cwd" })
      end,
    },
    {
      "folke/snacks.nvim",
      opts = {
        scope = {},
      },
      config = function()
        require("snacks").setup()
        vim.keymap.set("n", "gs", function()
          require("snacks").scope.jump()
        end, { desc = "jump to parent scope" })
      end,
    },
    {
      "MeanderingProgrammer/render-markdown.nvim",
      dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" }, -- if you use the mini.nvim suite
      -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' },        -- if you use standalone mini plugins
      -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
      ---@module 'render-markdown'
      ---@type render.md.UserConfig
      opts = {},
    },
  }
end
