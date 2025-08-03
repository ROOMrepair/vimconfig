if vim.g.vscode then
  return {}
else
  return {
    {
      "mason-org/mason.nvim",
      build = ":MasonUpdate",
      opts = {},
    },
    {
      "neovim/nvim-lspconfig",
      event = { "BufReadPost", "BufNewFile", "BufWritePre" },
      init = function()
        local icons = {
          -- see vim.diagnostic.severity
          [1] = "󰯹 ", -- error
          [2] = "󰰯 ", -- warn
          [3] = "󰰂 ", -- hint
          [4] = "󰰅 ", -- info
        }

        -- diagnostics
        local diagnostics = {
          underline = true,
          update_in_insert = false,
          virtual_lines = { current_line = true },
          virtual_text = {
            current_line = true,
            spacing = 2,
            source = "if_many",
            prefix = function(diagnostic)
              return icons[diagnostic.severity] or "󰘥 "
            end,
          },
          severity_sort = true,
          signs = {
            text = {
              [vim.diagnostic.severity.ERROR] = icons.ERROR,
              [vim.diagnostic.severity.WARN] = icons.WARN,
              [vim.diagnostic.severity.HINT] = icons.HINT,
              [vim.diagnostic.severity.INFO] = icons.INFO,
            },
          },
        }
        vim.diagnostic.config(diagnostics)
        vim.g.diagnostic_config = diagnostics
      end,
      config = function()
        local lsp = require("lspconfig")
        lsp.lua_ls.setup({
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
                maxPreload = 10000, -- performance
                preloadFileSize = 1000, -- performance
              },
              codeLens = {
                enable = true,
              },
              completion = {
                callSnippet = "Replace",
              },
              doc = {
                privateName = { "^_" },
              },
              hint = {
                enable = true,
                setType = false,
                paramType = true,
                paramName = "Disable",
                semicolon = "Disable",
                arrayIndex = "Disable",
              },
            },
          },
          capabilities = require("blink.cmp").get_lsp_capabilities(
            { workspace = { fileOperations = { didRename = true, willRename = true } } },
            true
          ),
          on_attach = function()
            vim.o.foldmethod = "expr"
          end,
        })

        lsp.clangd.setup({
          capabilities = require("blink.cmp").get_lsp_capabilities({}, true),
          cmd = {
            "clangd",
            "--clang-tidy",
            "--completion-style=detailed",
          },
          on_attach = function(client, bufnr)
            -- vim.notify(vim.inspect(client))
            local map = vim.keymap.set
            map("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Go to definition" })
            map("n", "gr", vim.lsp.buf.references, { buffer = bufnr, nowait = true, desc = "References" })
            map("n", "gy", vim.lsp.buf.type_definition, { buffer = bufnr, desc = "Go to type definition" })
            map("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr, desc = "Go to declaration" })
            map("n", "gI", vim.lsp.buf.implementation, { buffer = bufnr, desc = "Go to implementation" })
            map("n", "gK", function()
              return vim.lsp.buf.signature_help()
            end, { buffer = bufnr, desc = "Signature help" })
            vim.o.foldmethod = "expr"
          end,
        })
      end,
    },
  }
end
