return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = false,
  },
  {
    "stevearc/oil.nvim",
    enabled = true,
    lazy = false,
    opts = {},
    keys = {},
    dependencies = {
      "nvim-mini/mini.nvim",
      "ibhagwan/fzf-lua",
    },
    config = function(opts)
      local oil = require("oil")

      local function goen()
        local dir = oil.get_current_dir(0)
        if dir == nil then
          return
        end
        FzfLua.live_grep({ search_paths = dir })
      end

      vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "open parent directory" })
      vim.keymap.set("n", "_", "<CMD>Oil .<CR>", { desc = "open project cwd" })
      vim.keymap.set("n", "<leader>ge", goen, { desc = "current dir" })
      oil.setup(opts)
    end,
  },
}
