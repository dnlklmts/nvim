-- Change go imports order when starting to write the whole buffer to a file
local goimports = function (wait_ms)
  local params = vim.lsp.util.make_range_params()
  params.context = {only = {"source.organizeImports"}}
  local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
  for _, res in pairs(result or {}) do
    for _, r in pairs(res.result or {}) do
      if r.edit then
        vim.lsp.util.apply_workspace_edit(r.edit, "UTF-8")
      else
        vim.lsp.buf.execute_command(r.command)
      end
    end
  end
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
