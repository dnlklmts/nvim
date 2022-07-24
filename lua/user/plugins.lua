local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Since NVIM v0.4.0-464-g5eaa45547, commit 5eaa45547975c652e594d0d6dbe34c1316873dc7
-- 'secure' is set when 'modeline' is set, which will cause a lot of commands
-- cannot run in autocmd when opening help page.
-- https://github.com/neoclide/coc.nvim/issues/668#issuecomment-481975596
vim.cmd([[
  augroup secure_modeline_conflict_workaround
    autocmd!
    autocmd FileType help setlocal nomodeline
  augroup END
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

-- Install your plugins here
return packer.startup(function(use)
	-- My plugins here
	use("wbthomason/packer.nvim") -- Have packer manage itself
	use({ "nvim-lua/popup.nvim", disable = false }) -- An implementation of the Popup API from vim in Neovim
	use("nvim-lua/plenary.nvim") -- Useful lua functions used by lots of plugins
	use("windwp/nvim-autopairs") -- Auto close quote marks, brackets, etc
	use("numToStr/Comment.nvim") -- Easily comment stuff
	use("lewis6991/impatient.nvim") -- Speed up loading Lua modules in Neovim to improve startup time

	-- Colorschemes
	use("navarasu/onedark.nvim") -- Atom's One Dark and Light theme
	use({
		"nvim-lualine/lualine.nvim", -- Fast and easy to configure neovim statusline
		requires = {
			"kyazdani42/nvim-web-devicons", -- Adds file type icons
			disable = false,
			opt = true,
		},
	})

	-- UI
	use({
		"SmiteshP/nvim-navic", -- Simple winbar/statusline plugin that shows your current code context
		disable = true,
		requires = "neovim/nvim-lspconfig",
	})
	use({
		"kyazdani42/nvim-tree.lua",
		requires = {
			"kyazdani42/nvim-web-devicons", -- Adds file type icons
			disable = false,
		},
	})
	use("akinsho/bufferline.nvim") -- shows open buffers
	use("moll/vim-bbye") -- Delete buffers and close files in Vim without closing your windows
	use({
		"kevinhwang91/nvim-ufo", -- Adding folds high accuracy with Folding Range in LSP
		requires = "kevinhwang91/promise-async",
	})
	use("akinsho/toggleterm.nvim") -- floating terminal inside neovim
	use("ahmedkhalf/project.nvim") -- superior project management
	use({
		"goolord/alpha-nvim", -- fast and fully customizable greeter for neovim
		requires = "antoinemadec/FixCursorHold.nvim", -- fix lsp doc highlight
	})
	use("folke/which-key.nvim") -- opens a popup with suggestions to complete a key binding
	use("lukas-reineke/indent-blankline.nvim")

	-- cmp plugins
	use({
		"hrsh7th/nvim-cmp", -- The completion plugin
		requires = "onsails/lspkind.nvim", -- adds vscode-like pictograms to neovim built-in lsp
	})
	use("hrsh7th/cmp-buffer") -- buffer completions
	use("hrsh7th/cmp-path") -- path completions
	use("hrsh7th/cmp-cmdline") -- cmdline completions
	use("saadparwaiz1/cmp_luasnip") -- snippet completions
	use("hrsh7th/cmp-nvim-lsp") -- LSP completions
	use("hrsh7th/cmp-nvim-lua") -- Lua completion
	use("folke/lua-dev.nvim") -- full signature help, docs and completion for the nvim lua API

	-- snippets
	use("L3MON4D3/LuaSnip") -- snippet engine
	use("rafamadriz/friendly-snippets") -- a bunch of snippets to use  -- Automatically set up your configuration after cloning packer.nvim

	-- LSP support
	use("neovim/nvim-lspconfig") -- enable LSP
	use("williamboman/nvim-lsp-installer") -- simple to use language server installer
	use("RRethy/vim-illuminate") -- automatically highlighting other uses of the word under the cursor
	use("b0o/SchemaStore.nvim") -- JSON schemas for Neovim
	use("jose-elias-alvarez/null-ls.nvim") -- for formatters and linters

	-- Telescope
	use({
		"nvim-telescope/telescope.nvim",
		tag = "0.1.0",
		requires = "nvim-lua/plenary.nvim",
	})

	-- Treesitter
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
	})
	-- Context aware commenting using tree-sitter
	use("JoosepAlviste/nvim-ts-context-commentstring")

	-- Git
	use("lewis6991/gitsigns.nvim")

	-- Debugging
	-- Debug Adapter Protocol client
	use("mfussenegger/nvim-dap")

	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
