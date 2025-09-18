-- add this to your lua/plugins.lua, lua/plugins/init.lua,  or the file you keep your other plugins:
return {
  "numToStr/Comment.nvim",
  keys = {
    { "<C-_>", function() require("Comment.api").toggle.linewise.current() end, mode = "n", desc = "Toggle comment" },
    {
      "<C-_>",
      function()
        -- Toggle in VISUAL mode
        local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
        vim.api.nvim_feedkeys(esc, "nx", false)
        require("Comment.api").toggle.linewise(vim.fn.visualmode())
      end,
      mode = "x",
      desc = "Toggle comment",
    },
  },
  opts = {
    -- add any options here
  },
}
