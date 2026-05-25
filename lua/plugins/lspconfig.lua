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
    dependencies = {
      "saghen/blink.cmp",
    },
    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      local on_attach = function(client, bufnr)
        local opts = { noremap = true, silent = true, buffer = bufnr }

        vim.notify("LSP attached: " .. client.name, vim.log.levels.INFO)
      end

      -- lua_ls
      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
      })
      vim.lsp.enable("lua_ls")

      -- clangd
      vim.lsp.config("clangd", {
        capabilities = capabilities,
        on_attach = on_attach,
      })
      vim.lsp.enable("clangd")

      -- ts_ls
      vim.lsp.config("ts_ls", {
        capabilities = capabilities,
      })
      vim.lsp.enable("ts_ls")

      -- python
      vim.lsp.config("pyright", {
        capabilities = capabilities,
      })
      vim.lsp.enable("pyright")

      -- cmake
      -- vim.lsp.config("cmake", {
      --   cmd = { "cmake-language-server" },
      --   filetypes = { "cmake" },
      --   root_markers = { "CMakePresets.json", "CTestConfig.cmake", ".git", "build", "cmake" },
      --   init_options = {
      --     buildDirectory = "build",
      --   },
      --   capabilities = capabilities,
      --   on_attach = on_attach,
      -- })
      --
      -- vim.lsp.enable("cmake")

      -- rust
      vim.lsp.config("rust_analyzer", {
        capabilities = capabilities,
      })
      vim.lsp.enable("rust_analyzer")

      --& jumps
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "go to definition" })

      --& diagnostic
      vim.diagnostic.config({
        severity_sort = true,
        float = { border = "rounded", source = "if_many" },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.INFO] = " ",
            [vim.diagnostic.severity.HINT] = " ",
          },
        },
        virtual_text = {
          source = "if_many",
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      })
    end,
  },
}
