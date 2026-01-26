return {
  "petertriho/nvim-scrollbar",
  config = function()
    require("scrollbar").setup({
      handlers = {
        gitsigns = true, -- gitsignsと連携して差分を表示
      },
    })
  end,
}
