-- Unfold code blocks after a buffer is displayed in a window
-- vim.api.nvim_create_autocmd(
--   { "BufWinEnter", "BufReadPost", "FileReadPost" }, {
--     pattern = { "*" },
--     callback = function()
--       vim.cmd "normal zR"
--     end,
-- })

-- Change go imports order when starting to write the whole buffer to a file
local goimports = function ()
      require("user.lsp.handlers").goimports(1000)
end
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = goimports
})

-- Save cursor last position
-- from :help last-position-jump
local savePosition = function ()
  vim.cmd [[
    autocmd FileType <buffer> ++once
      \ if &ft !~# 'commit\|rebase' && line("'\"") > 1 && line("'\"") <= line("$") | exe 'normal! g`"' | endif
  ]]
end
vim.api.nvim_create_autocmd("BufRead",{
  pattern = "*",
  callback = savePosition
})
