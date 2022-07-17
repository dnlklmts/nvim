local status_ok, project = pcall(require, "project_nvim")
if not status_ok then
	vim.notify("failed to load project plugin")
	return
end

project.setup({
	-- Do not automatically change root directory
	manual_mode = false,
	-- Methods of detecting the root directory:
	--   * "lsp" uses the native neovim lsp
	--   * "pattern" uses vim-rooter like glob pattern matching
	-- Order matters.
	detection_methods = { "lsp", "pattern" },
	-- Patterns used to detect root dir in pattern mode
	patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },
	-- Table of lsp clients to ignore
	ignore_lsp = {},
	-- Do not calculate root dir on dirs
	exclude_dirs = {},
	-- Notify when plugin change root dir
	silent_chdir = true,
	-- Path to store project history for telescope integration
	datapath = vim.fn.stdpath("data"),
})

-- Enable telescope integration
-- https://github.com/ahmedkhalf/project.nvim#telescope-mappings
local ts_status_ok, telescope = pcall(require, "telescope")
if not ts_status_ok then
	vim.notify("failed to load telescope plugin")
	return
end
telescope.load_extension("projects")
