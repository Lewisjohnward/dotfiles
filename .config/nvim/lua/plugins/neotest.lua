return {
  "nvim-neotest/neotest",

  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",

    -- Backend: Jest
    "nvim-neotest/neotest-jest",

    -- Frontend: Vitest
    "marilari88/neotest-vitest",
  },

  config = function()
    local jest = require "neotest-jest"
    local vitest = require "neotest-vitest"

    require("neotest").setup {
      summary = {
        open = "botright vsplit | vertical resize 100",

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

      output_panel = {
        open = "botright vsplit | vertical resize 80",
      },

      adapters = {
        -- ==========================================
        -- BACKEND: JEST
        -- ==========================================
        jest {
          jestCommand = "npx jest --colors",

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

        -- ==========================================
        -- FRONTEND: VITEST
        -- ==========================================
        vitest {
          vitestCommand = "npx vitest",

          vitestConfigFile = function(file)
            if string.find(file, "integration") or string.find(file, "__tests__") then
              return "vitest.integration.config.ts"
            end

            return "vitest.unit.integration.ts"
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
