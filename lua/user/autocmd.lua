local cmp_ok, cmp = pcall(require, "cmp")
if not cmp_ok then
	vim.notify("failed to load cmp plugin")
	return
end

-- Change go imports order when starting to write the whole buffer to a file
local goimports = function(wait_ms)
	local params = vim.lsp.util.make_range_params()
	params.context = { only = { "source.organizeImports" } }
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
	callback = goimports,
})

-- Save cursor last position
-- from :help last-position-jump
vim.api.nvim_create_autocmd("BufRead", {
	pattern = "*",
	callback = function()
		vim.cmd([[
      autocmd FileType <buffer> ++once
        \ if &ft !~# 'commit\|rebase' && line("'\"") > 1 && line("'\"") <= line("$") | exe 'normal! g`"' | endif
    ]])
	end,
})

--[[
-- Make autocompletions appear automatically if there's non empty space before the cursor and nothing in front of it.
vim.api.nvim_create_autocmd( {"TextChangedI", "TextChangedP"}, {
    callback = function()
      local line = vim.api.nvim_get_current_line()
      local cursor = vim.api.nvim_win_get_cursor(0)[2]

      local current = string.sub(line, cursor, cursor + 1)
      if current == "." or current == "," or current == " " then
        cmp.close()
      end

      local before_line = string.sub(line, 1, cursor + 1)
      local after_line = string.sub(line, cursor + 1, -1)
      if not string.match(before_line, "^%s+$") then
        if after_line == "" or string.match(before_line, " $") or string.match(before_line, "%.$") then
          cmp.complete()
        end
      end
  end,
  pattern = "*"
})
--]]

-- https://vi.stackexchange.com/a/1985
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*",
	callback = function()
		vim.cmd([[ set fo-=c fo-=r fo-=o ]])
	end,
})

-- Code formatting after saving file
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function()
		vim.lsp.buf.formatting_sync({ async = true })
	end,
})

-- Disable line numbers for terminal buftype
vim.api.nvim_create_autocmd("TermOpen", {
	pattern = "*",
	callback = function()
		vim.cmd([[ setlocal nonumber norelativenumber ]])
	end,
})

-- Disable spellchecker for terminal buftype
vim.api.nvim_create_autocmd("TermOpen", {
	pattern = "*",
	callback = function()
		vim.cmd([[ setlocal spell false]])
	end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = function()
		-- bg = "#242b38", border = "#4dbdcb"
		vim.api.nvim_set_hl(0, "NormalFloat", { link = "TelescopeNormal" })
		vim.api.nvim_set_hl(0, "FloatBorder", { link = "TelescopeResultsBorder" })
		-- vim.api.nvim_set_hl(0, "CursorLine", { link = "TelescopeSelection" })
	end,
})

-- Disable statusline and tabline when open greeter dashboard
vim.api.nvim_create_autocmd({ "User" }, {
	pattern = "AlphaReady",
	callback = function()
		vim.cmd([[
      set laststatus=0 | autocmd BufUnload <buffer> set laststatus=3
      set showtabline=0 | autocmd BufUnload <buffer> set showtabline=2
    ]])
	end,
})
