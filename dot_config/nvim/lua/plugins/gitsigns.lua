return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = true,
      },
    },
    config = function(_, opts)
      require("gitsigns").setup(opts)

      local function set_pr_base()
        vim.fn.jobstart({ "gh", "pr", "view", "--json", "baseRefName", "-q", ".baseRefName" }, {
          stdout_buffered = true,
          on_stdout = function(_, data)
            if data and data[1] and data[1] ~= "" then
              local base_branch = "origin/" .. data[1]
              require("gitsigns").change_base(base_branch, true)
              vim.notify("Gitsigns: comparing with " .. base_branch, vim.log.levels.INFO)
            end
          end,
        })
      end

      -- Run immediately after setup
      set_pr_base()

      -- Also run on directory change
      vim.api.nvim_create_autocmd("DirChanged", {
        callback = set_pr_base,
        desc = "Auto-set gitsigns base to PR base branch",
      })
    end,
  },
}
