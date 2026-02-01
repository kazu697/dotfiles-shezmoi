-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--

vim.keymap.set("n", "<C-a>", "ggVG")
-- insert mode
vim.keymap.set("i", "<C-d>", "<Del>", { noremap = true, silent = true })

-- Buffer navigation
vim.keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
vim.keymap.set("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
vim.keymap.set("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })

-- Buffer management
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete Buffer" })
vim.keymap.set("n", "<leader>bD", "<cmd>bdelete!<cr>", { desc = "Delete Buffer (Force)" })
vim.keymap.set("n", "<leader>bo", "<cmd>%bdelete|edit#|bdelete#<cr>", { desc = "Delete Other Buffers" })

-- File search with vertical split
vim.keymap.set("n", "<leader>fv", function()
  Snacks.picker.files({
    confirm = function(picker, item)
      picker:close()
      if item and item.file then
        vim.cmd("vsplit " .. vim.fn.fnameescape(item.file))
      end
    end,
  })
end, { desc = "Find Files (vsplit)" })

-- Copy git root relative path to clipboard
vim.keymap.set("n", "<leader>yr", function()
  -- Get absolute path of current buffer
  local filepath = vim.fn.expand("%:p")

  -- Check if buffer has a filename
  if filepath == "" then
    vim.notify("No file associated with current buffer", vim.log.levels.WARN)
    return
  end

  -- Get git root using git rev-parse
  local gitroot =
    vim.fn.system("git -C " .. vim.fn.shellescape(vim.fn.expand("%:p:h")) .. " rev-parse --show-toplevel 2>/dev/null")
  gitroot = gitroot:gsub("\n", "") -- Remove trailing newline

  -- Check if git command succeeded
  if vim.v.shell_error ~= 0 or gitroot == "" then
    vim.notify("Not in a git repository", vim.log.levels.WARN)
    return
  end

  -- Calculate relative path
  local relative = vim.fn.fnamemodify(filepath, ":s?" .. gitroot .. "/??")

  -- Copy to system clipboard (+ register)
  vim.fn.setreg("+", relative)

  -- Notify user with success message
  vim.notify("Copied (git relative): " .. relative)
end, { desc = "Copy git root relative path" })
