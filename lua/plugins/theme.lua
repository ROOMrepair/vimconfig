if vim.g.vscode then
  return {}
else
  return {
    {
      "folke/tokyonight.nvim",
      priority = 1000,
      lazy = false,
    },
    {
      "catppuccin/nvim",
      name = "catppuccin",
      lazy = false,
      priority = 1000,
      opts = {
        transparent_background = true,
        flavour = "auto",
        background = {
          light = "frappe",
          dark = "mocha",
        },
      },
      -- config = function(_, opts)
      --   require("catppuccin").setup(opts)
      -- end,
    },
    {
      "bluz71/vim-moonfly-colors",
      name = "moonfly",
      lazy = false,
      priority = 1001,
      moonflyTransparent = true,
      -- config = function(_, opts)
      --   require("moonfly").setup(opts)
      --   vim.cmd.colorscheme = "moonfly"
      -- end,
    },
  }
end
