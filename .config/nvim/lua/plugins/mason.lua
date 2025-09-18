-- Customize Mason

---@type LazySpec
return {
  -- use mason-tool-installer for automatically installing Mason packages
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    -- overrides `require("mason-tool-installer").setup(...)`
    opts = {
      -- Make sure to use the names found in `:Mason`
      ensure_installed = {
        -- install language servers
        "lua-language-server",

        -- install formatters
        "stylua",

        -- install debuggers
        "debugpy",

        -- install any other package
        "tree-sitter-cli",

        "prettier", -- Note: it's "prettier" not "prettierd" in mason-tool-installer
        "lua-language-server", -- Note: it's "lua-language-server" not "lua_ls"
        "emmet-ls",
        "tailwindcss-language-server",
        "typescript-language-server",

        -- Formatters/Linters
        "black", -- Python formatter
        "isort", -- Python import sorter
        "flake8", -- Python linter

        -- LSP Servers
        "pyright", -- Python LSP server
      },
    },
  },
}
