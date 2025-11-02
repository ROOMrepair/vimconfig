return {
  {
    "mason-org/mason.nvim",
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    init = function()
      -- local icons = {
      --   -- see vim.diagnostic.severity
      --   [1] = "󰯹 ", -- error
      --   [2] = "󰰯 ", -- warn
      --   [3] = "󰰂 ", -- hint
      --   [4] = "󰰅 ", -- info
      -- }
      --
      -- -- diagnostics
      -- local diagnostics = {
      --   underline = true,
      --   update_in_insert = false,
      --   virtual_lines = { current_line = true },
      --   virtual_text = {
      --     current_line = true,
      --     spacing = 2,
      --     source = "if_many",
      --     prefix = function(diagnostic)
      --       return icons[diagnostic.severity] or "󰘥 "
      --     end,
      --   },
      --   float = {
      --     border = "rounded",
      --     scope = "line",
      --   },
      --   severity_sort = true,
      --   signs = {
      --     text = {
      --       [vim.diagnostic.severity.ERROR] = icons.ERROR,
      --       [vim.diagnostic.severity.WARN] = icons.WARN,
      --       [vim.diagnostic.severity.HINT] = icons.HINT,
      --       [vim.diagnostic.severity.INFO] = icons.INFO,
      --     },
      --   },
      -- }
      -- vim.diagnostic.config(diagnostics)
    end,
  },
}
