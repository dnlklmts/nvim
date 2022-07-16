local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
	return
end

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
local actions = null_ls.builtins.code_actions
local completion = null_ls.builtins.completion

null_ls.setup({
	debug = false,
	sources = {
		-- Code actions
		actions.gitsigns,

		-- Completion
		completion.spell,
		-- completion.luasnip,

		-- Diagnostics
		diagnostics.codespell,
		diagnostics.staticcheck,
		-- diagnostics.golangci_lint,
		diagnostics.luacheck.with({
			extra_args = { "--read-globals", "vim" },
		}),
		diagnostics.shellcheck,
		diagnostics.sqlfluff.with({
			extra_args = { "--dialect", "postgres" }, -- change to your dialect
		}),
		diagnostics.write_good,
		diagnostics.yamllint,

		-- Formatting
		formatting.stylua,
		formatting.codespell,
		formatting.gofmt,
		formatting.goimports,
		formatting.golines,
		formatting.jq,
		formatting.sqlfluff.with({
			extra_args = { "--dialect", "postgres" }, -- change to your dialect
		}),
		-- formatting.pg_format,
	},
})
