-- GitHub integration with Octo.nvim
return {
  {
    "pwntester/octo.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "folke/snacks.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    cmd = "Octo",
    keys = {
      { "<leader>gi", "<cmd>Octo issue list<cr>", desc = "List Issues" },
      { "<leader>gI", "<cmd>Octo issue create<cr>", desc = "Create Issue" },
      { "<leader>gp", "<cmd>Octo pr list<cr>", desc = "List PRs" },
      { "<leader>gP", "<cmd>Octo pr create<cr>", desc = "Create PR" },
      { "<leader>gr", "<cmd>Octo review start<cr>", desc = "Start Review" },
    },
    opts = {
      enable_builtin = true,
      default_to_projects_v2 = true,
      ssh_aliases = {},
      picker = "snacks",
      use_local_fs = true,
      gh_env = {
        GH_PAGER = "",
      },
      timeout = 10000,
      ui = {
        use_signcolumn = true, -- サイン列にコメントマーカー表示
        use_signstatus = true, -- PRステータス表示
      },
      issues = {
        order_by = {
          field = "UPDATED_AT",
          direction = "DESC",
        },
      },
      pull_requests = {
        order_by = {
          field = "UPDATED_AT",
          direction = "DESC",
        },
      },
      mappings_disable_default = false,
      mappings = {
        review_diff = {
          add_review_comment = { lhs = "<leader>ca", desc = "Add review comment" },
          add_review_suggestion = { lhs = "<leader>cs", desc = "Add review suggestion" },
        },
        review_thread = {
          add_comment = { lhs = "<leader>ca", desc = "Add comment" },
          delete_comment = { lhs = "<leader>cd", desc = "Delete comment" },
        },
      },
    },
  },
}
