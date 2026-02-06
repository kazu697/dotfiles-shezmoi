-- Go language support with treesitter, LSP, and DAP
return {
  -- LazyVim Go extras: treesitter + gopls + DAP + mason
  { import = "lazyvim.plugins.extras.lang.go" },

  -- Configure gopls inlay hints and add golangci-lint-langserver
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
        -- golangci-lint language server（gopls と併用して lint 診断を提供）
        golangci_lint_ls = {
          -- プロジェクトルートにカスタムバイナリがあれば使用
          on_new_config = function(config, root_dir)
            local custom_lint = root_dir .. "/.linter/custom-golangci-lint"
            if vim.fn.executable(custom_lint) == 1 then
              config.init_options = config.init_options or {}
              config.init_options.command = { custom_lint, "run", "--out-format", "json" }
            end
          end,
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
        "golangci-lint",
        "golangci-lint-langserver",
      },
    },
  },
}
