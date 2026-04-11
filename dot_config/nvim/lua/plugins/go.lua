-- Go language support with treesitter, LSP, and DAP
return {
  -- LazyVim Go extras: treesitter + gopls + DAP + mason
  { import = "lazyvim.plugins.extras.lang.go" },

  -- Configure gopls inlay hints
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = {
        enabled = true,
      },
      servers = {
        gopls = {
          settings = {
            gopls = {
              hints = {
                assignVariableTypes = false,
                compositeLiteralFields = false,
                compositeLiteralTypes = false,
                constantValues = false,
                functionTypeParameters = false,
                parameterNames = true,
                rangeVariableTypes = false,
              },
            },
          },
        },
      },
    },
  },

  -- mason.nvim で必要なツールを自動インストール
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "gopls",
      },
    },
  },
}
