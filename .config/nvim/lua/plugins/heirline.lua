return {
  "rebelot/heirline.nvim",
  opts = function(_, opts)
    local status = require "astroui.status"

    opts.winbar = {
      fallthrough = false,

      {
        condition = function() return vim.bo.buftype == "" end,

        init = function(self)
          self.filename = vim.api.nvim_buf_get_name(0)
          self.bufnr = vim.api.nvim_get_current_buf()
        end,

        -- File icon
        {
          provider = function(self)
            if self.filename == "" then return "" end

            local extension = vim.fn.fnamemodify(self.filename, ":e")

            return require("nvim-web-devicons").get_icon(self.filename, extension, { default = true }) .. " "
          end,

          hl = { fg = "#9296a1" },
        },

        -- Directory path
        {
          provider = function(self)
            if self.filename == "" then return "" end

            local path = vim.fn.fnamemodify(self.filename, ":~:.")
            local directory = vim.fn.fnamemodify(path, ":h")

            if directory == "." then return "" end

            return directory .. "/"
          end,

          hl = { fg = "#9296a1" },
        },

        -- Filename: brighter in active windows
        {
          provider = function(self)
            if self.filename == "" then return "" end

            return vim.fn.fnamemodify(self.filename, ":t")
          end,

          hl = function()
            if status.condition.is_active() then return { fg = "#b0b4bf" } end

            return { fg = "#797d87" }
          end,
        },

        -- Unsaved changes
        {
          condition = function(self) return vim.bo[self.bufnr].modified end,

          provider = " [+]",

          hl = { fg = "#e0af68" },
        },
      },
    }

    return opts
  end,
}
