local M = {}

M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem.snippetSupport = true
M.capabilities.textDocument.completion.completionItem.resolveSupport = {
	properties = {
		"documentation",
		"detail",
		"additionalTextEdits",
	},
}

local status_cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_cmp_ok then
	return
end
M.capabilities = cmp_nvim_lsp.update_capabilities(M.capabilities)

M.setup = function()
	local icons = require("user.icons")
	local signs = {
		{ name = "DiagnosticSignError", text = icons.diagnostics.Error },
		{ name = "DiagnosticSignWarn", text = icons.diagnostics.Warning },
		{ name = "DiagnosticSignHint", text = icons.diagnostics.Hint },
		{ name = "DiagnosticSignInfo", text = icons.diagnostics.Information },
	}

	for _, sign in ipairs(signs) do
		vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
	end

	local config = {
		virtual_text = false,
		signs = {
			active = signs,
		},
		update_in_insert = true,
		underline = true,
		severity_sort = true,
		float = {
			focusable = true,
			style = "minimal",
			border = "rounded",
			source = "always",
			header = "",
			prefix = "",
		},
	}

	vim.diagnostic.config(config)

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "rounded",
		width = 60,
	})

	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
		border = "rounded",
		width = 60,
	})
end

local function lsp_highlight_document(client)
	local status_ok, illuminate = pcall(require, "illuminate")
	if not status_ok then
		return
	end
	illuminate.on_attach(client)
end

local function lsp_keymaps(bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	local opts = { noremap = true, silent = true }
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	local keymap = vim.keymap.set

	keymap("n", "gl", vim.diagnostic.open_float, opts)
	keymap("n", "[d", vim.diagnostic.goto_prev, opts)
	keymap("n", "]d", vim.diagnostic.goto_next, opts)
	keymap("n", "<Leader>sl", vim.diagnostic.setloclist, opts)

	keymap("n", "gD", vim.lsp.buf.declaration, bufopts)
	keymap("n", "gd", vim.lsp.buf.definition, bufopts)
	keymap("n", "K", vim.lsp.buf.hover, bufopts)
	keymap("n", "gi", vim.lsp.buf.implementation, bufopts)
	keymap("n", "gs", vim.lsp.buf.signature_help, bufopts)
	keymap("n", "<Leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
	keymap("n", "<Leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
	keymap("n", "<Leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, bufopts)
	keymap("n", "<Leader>td", vim.lsp.buf.type_definition, bufopts)
	keymap("n", "<Leader>rn", vim.lsp.buf.rename, bufopts)
	keymap("n", "<Leader>ca", vim.lsp.buf.code_action, bufopts)
	keymap("n", "gr", vim.lsp.buf.references, bufopts)
	keymap("n", "<M-f>", function()
		vim.lsp.buf.formatting({ async = true })
	end, bufopts)
end

M.on_attach = function(client, bufnr)
	if client.name == "sumneko_lua" then
		client.resolved_capabilities.document_formatting = false
	end
	lsp_keymaps(bufnr)
	lsp_highlight_document(client)
end

function M.enable_format_on_save()
	vim.cmd([[
    augroup format_on_save
      autocmd! 
      autocmd BufWritePre * lua vim.lsp.buf.formatting_sync({ async = true })
    augroup end
  ]])
	vim.notify("Enabled format on save")
end

function M.disable_format_on_save()
	M.remove_augroup("format_on_save")
	vim.notify("Disabled format on save")
end

function M.toggle_format_on_save()
	if vim.fn.exists("#format_on_save#BufWritePre") == 0 then
		M.enable_format_on_save()
	else
		M.disable_format_on_save()
	end
end

function M.remove_augroup(name)
	if vim.fn.exists("#" .. name) == 1 then
		vim.cmd("au! " .. name)
	end
end

vim.cmd([[ command! LspToggleAutoFormat execute 'lua require("user.lsp.handlers").toggle_format_on_save()' ]])

return M
