-- Unfold code blocks after a buffer is displayed in a window
vim.api.nvim_create_autocmd(
  {
    -- "BufWinEnter",
    -- "BufFilePost",
    "BufReadPre",
    "BufReadPost",
    "FileReadPre",
    "FileReadPost",
    -- "BufWritePost",
    -- "InsertLeave",
  },
  {
    pattern = { "*" },
    callback = function()
      vim.cmd "normal zR"
    end,
})

-- Change go imports order when starting to write the whole buffer to a file
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*.go" },
  callback = function()
    require("user.lsp.handlers").goimports(1000)
  end,
})

