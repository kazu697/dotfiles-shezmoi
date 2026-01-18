return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewFileHistory" },
  keys = {
    { "<leader>dv", "<cmd>DiffviewOpen<cr>", desc = "Diffview: Open" },
    { "<leader>df", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview: Current file history" },
    { "<leader>dq", "<cmd>DiffviewClose<cr>", desc = "Diffview: Close" },
  },
  opts = {
    view = {
      default = {
        layout = "diff2_horizontal",
      },
    },
  },
}
