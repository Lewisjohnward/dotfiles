return {
  {
    "folke/snacks.nvim",
    opts = function()
      vim.api.nvim_create_user_command("Tsc", function()
        local output = vim.fn.systemlist "npx tsc -b --noEmit 2>&1"

        vim.fn.setqflist({}, " ", {
          title = "TypeScript build",
          lines = output,
          efm = "%f(%l\\,%c): %m",
        })

        Snacks.picker.qflist()
      end, {
        desc = "TypeScript build check",
      })
    end,
  },
}
