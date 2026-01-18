-- Go language support with treesitter, LSP, and DAP
return {
  -- LazyVim Go extras: treesitter + gopls + DAP + mason
  { import = "lazyvim.plugins.extras.lang.go" },

  -- Configure inlay hints: show parameter names only, hide variable types
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
                parameterNames = true, -- 関数の引数名を表示
                rangeVariableTypes = false,
              },
            },
          },
        },
      },
    },
  },
}
