return {
  "nvim-neotest/neotest",

  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",

    -- IMPORTANT: must be here
    "nvim-neotest/neotest-jest",
  },

  config = function()
    local jest = require "neotest-jest"

    require("neotest").setup {
      summary = {
        mappings = {
          jumpto = "<CR>",
          run = "r",
          output = "o",
          mark = "m",
          mark_all = "M",
          clear_marked = "c",
          expand = "e",
          stop = "S",
        },
      },
      adapters = {
        jest {
          jestCommand = "npx jest --colors",

          -- 🔥 key part: choose config based on file path
          jestConfigFile = function(file)
            if string.find(file, "integration") or string.find(file, "__test__") then
              return "jest.config.integration.ts"
            end

            return "jest.config.unit.ts"
          end,

          cwd = function() return vim.fn.getcwd() end,

          env = {
            CI = true,
          },
        },
      },
    }
  end,
}
