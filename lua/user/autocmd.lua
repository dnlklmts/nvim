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

vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = function()
		-- normalBg = "#242b38", telescopeBorderFg = "#4dbdcb", cursorSelBg = "#2d3343"
		vim.api.nvim_set_hl(0, "Pmenu", { bg = "#242b38" })
		vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#2d3343" })
		vim.api.nvim_set_hl(0, "NormalFloat", { link = "Pmenu" })
		vim.api.nvim_set_hl(0, "FloatBorder", { link = "Pmenu" })
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

-- Enable spellcheker for specified file types
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "gitcommit", "markdown", "text" },
	callback = function()
		vim.cmd([[
      setlocal wrap
      setlocal spell spelllang=en,ru
    ]])
	end,
})

-- Make all windows equal height & width
vim.api.nvim_create_autocmd("VimResized", {
	pattern = "*",
	callback = function()
		vim.cmd([[ tabdo wincmd = ]])
	end,
})

-- Quit manual page with `q`
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "qf", "help", "man", "lspinfo" },
	callback = function()
		vim.cmd([[
      nnoremap <silent> <buffer> q :close<CR>
    ]])
	end,
})
