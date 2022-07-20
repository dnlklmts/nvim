local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
	return
end

local setup = {
	plugins = {
		marks = true, -- shows a list of your marks on ' and `
		registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
		spelling = {
			enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
			suggestions = 20, -- how many suggestions should be shown in the list?
		},
		-- the presets plugin, adds help for a bunch of default keybindings in Neovim
		-- No actual key bindings are created
		presets = {
			operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
			motions = false, -- adds help for motions
			text_objects = false, -- help for text objects triggered after entering an operator
			windows = true, -- default bindings on <c-w>
			nav = true, -- misc bindings to work with windows
			z = true, -- bindings for folds, spelling and others prefixed with z
			g = true, -- bindings for prefixed with g
		},
	},
	-- add operators that will trigger motion and text object completion
	-- to enable all native operators, set the preset / operators plugin above
	-- operators = { gc = "Comments" },
	key_labels = {
		-- override the label used to display some keys. It doesn't effect WK in any other way.
		-- For example:
		-- ["<space>"] = "SPC",
		-- ["<CR>"] = "RET",
		-- ["<tab>"] = "TAB",
	},
	icons = {
		breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
		separator = "➜", -- symbol used between a key and it's label
		group = "+", -- symbol prepended to a group
	},
	popup_mappings = {
		scroll_down = "<c-d>", -- binding to scroll down inside the popup
		scroll_up = "<c-u>", -- binding to scroll up inside the popup
	},
	window = {
		border = "rounded", -- none, single, double, shadow
		position = "bottom", -- bottom, top
		margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
		padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
		winblend = 0,
	},
	layout = {
		height = { min = 4, max = 25 }, -- min and max height of the columns
		width = { min = 20, max = 50 }, -- min and max width of the columns
		spacing = 3, -- spacing between columns
		align = "left", -- align columns left, center or right
	},
	ignore_missing = true, -- enable this to hide mappings for which you didn't specify a label
	hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
	show_help = true, -- show help message on the command line when the popup is visible
	triggers = "auto", -- automatically setup triggers
	-- triggers = {"<Leader>"} -- or specify a list manually
	triggers_blacklist = {
		-- list of mode / prefixes that should never be hooked by WhichKey
		-- this is mostly relevant for key maps that start with a native binding
		-- most people should not need to change this
		i = { "j", "k" },
		v = { "j", "k" },
	},
}

local opts = {
	mode = "n", -- NORMAL mode
	prefix = "<Leader>",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
}

local mappings = {
	["/"] = { '<cmd>lua require("Comment.api").toggle_current_linewise()<CR>', "Comment" },
	["a"] = { "<cmd>Alpha<CR>", "Alpha" },
	["e"] = { "<cmd>NvimTreeToggle<CR>", "Explorer" },
	["w"] = { "<cmd>w!<CR>", "Save" },
	["q"] = { "<cmd>q!<CR>", "Quit" },
	["h"] = { "<cmd>nohlsearch<CR>", "No Highlight" },
	["f"] = {
		function()
			return require("telescope.builtin").find_files(require("telescope.themes").get_dropdown({
				previewer = false,
				winblend = 10,
			}))
		end,
		"Find files",
	},
	["F"] = { "<cmd>Telescope live_grep<CR>", "Find Text" },
	["p"] = { "<cmd>Telescope projects<CR>", "Projects" },

	b = {
		name = "Buffers",
		l = {
			function()
				return require("telescope.builtin").buffers(
					require("telescope.themes").get_dropdown({ previewer = false })
				)
			end,
			"List All Buffers",
		},
		c = { "<cmd>Bdelete %<CR>", "Close Buffer" },
		q = { "<cmd>:bufdo :Bdelete<CR>", "Close All Buffers" },
	},
	P = {
		name = "Packer",
		c = { "<cmd>PackerCompile<CR>", "Compile" },
		i = { "<cmd>PackerInstall<CR>", "Install" },
		s = { "<cmd>PackerSync<CR>", "Sync" },
		S = { "<cmd>PackerStatus<CR>", "Status" },
		u = { "<cmd>PackerUpdate<CR>", "Update" },
	},

	g = {
		name = "Git",
		g = { "<cmd>lua _LAZYGIT_TOGGLE()<CR>", "Lazygit" },
		j = { "<cmd>lua require 'gitsigns'.next_hunk()<CR>", "Next Hunk" },
		k = { "<cmd>lua require 'gitsigns'.prev_hunk()<CR>", "Prev Hunk" },
		s = { "<cmd>lua require 'gitsigns'.stage_hunk()<CR>", "Stage Hunk" },
		r = { "<cmd>lua require 'gitsigns'.reset_hunk()<CR>", "Reset Hunk" },
		S = { "<cmd>lua require 'gitsigns'.stage_buffer()<CR>", "Stage Buffer" },
		u = {
			"<cmd>lua require 'gitsigns'.undo_stage_hunk()<CR>",
			"Undo Stage Hunk",
		},
		R = { "<cmd>lua require 'gitsigns'.reset_buffer()<CR>", "Reset Buffer" },
		p = { "<cmd>lua require 'gitsigns'.preview_hunk()<CR>", "Preview Hunk" },
		l = { "<cmd>lua require 'gitsigns'.blame_line({ full = true })<CR>", "Blame" },
		t = { "<cmd>lua require 'gitsigns'.toggle_current_line_blame()<CR>", "Toggle Blame" },
		d = { "<cmd>lua require 'gitsigns'.diffthis()<CR>", "Diff" },
		H = {
			"<cmd>Gitsigns diffthis ~<CR>",
			"Diff HEAD",
		},
		D = { "<cmd>lua require 'gitsigns'.toggle_deleted()<CR>", "Show Deleted" },
		o = { "<cmd>Telescope git_status<CR>", "Open changed file" },
		b = { "<cmd>Telescope git_branches<CR>", "Checkout branch" },
		c = { "<cmd>Telescope git_commits<CR>", "Checkout commit" },
		h = { "<cmd>lua require 'gitsigns'.select_hunk()<CR>", "Select Hunk" },
	},

	l = {
		name = "LSP",
		d = {
			name = "Diagnostics",
			h = {
				function()
					return vim.diagnostic.open_float()
				end,
				"Show Diagnostics",
			},
			d = {
				"<cmd>Telescope diagnostics<CR>",
				"Document Diagnostics",
			},
			j = {
				function()
					return vim.diagnostic.goto_next()
				end,
				"Next Diagnostic",
			},
			k = {
				function()
					return vim.diagnostic.goto_prev()
				end,
				"Prev Diagnostic",
			},
			q = {
				function()
					return vim.diagnostic.setloclist()
				end,
				"Quickfix",
			},
			s = { "<cmd>Telescope lsp_document_symbols<CR>", "Document Symbols" },
			w = {
				"<cmd>Telescope lsp_dynamic_workspace_symbols<CR>",
				"Workspace Symbols",
			},
		},
		j = {
			name = "Jump to",
			d = {
				function()
					return vim.lsp.buf.declaration()
				end,
				"Declaration",
			},
			D = {
				function()
					return vim.lsp.buf.definition()
				end,
				"Definition",
			},
			i = {
				function()
					return vim.lsp.buf.implementation()
				end,
				"Implementation",
			},
			r = {
				function()
					return require("telescope.builtin").lsp_references(require("telescope.themes").get_cursor({
						winblend = 10,
					}))
				end,
				"References",
			},
			t = {
				function()
					return vim.lsp.buf.type_definition()
				end,
				"Type Definition",
			},
		},
		w = {
			name = "Workspaces",
			a = {
				function()
					return vim.lsp.buf.add_workspace_folder()
				end,
				"Add Workspace",
			},
			r = {
				function()
					return vim.lsp.buf.remove_workspace_folder()
				end,
				"Remove Workspace",
			},
			l = {
				function()
					print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				end,
				"List Workspaces",
			},
		},
		s = {
			name = "Symbols",
			a = {
				function()
					return vim.lsp.buf.code_action()
				end,
				"Code Action",
			},
			h = {
				function()
					return vim.lsp.buf.hover()
				end,
				"Hover Info",
			},
			l = {
				function()
					vim.lsp.codelens.run()
				end,
				"CodeLens Actions",
			},
			r = {
				function()
					return vim.lsp.buf.rename()
				end,
				"Rename",
			},
			s = {
				function()
					return vim.lsp.buf.signature_help()
				end,
				"Signature Help",
			},
		},
		f = {
			function()
				return vim.lsp.buf.formatting_sync()
			end,
			"Format",
		},
		i = { "<cmd>LspInfo<CR>", "Info" },
		I = { "<cmd>LspInstallInfo<CR>", "Installer Info" },
	},
	s = {
		name = "Search",
		t = { "<cmd>Telescope colorscheme<CR>", "Colorscheme" },
		h = { "<cmd>Telescope help_tags<CR>", "Find Help" },
		m = { "<cmd>Telescope man_pages<CR>", "Man Pages" },
		o = { "<cmd>Telescope oldfiles<CR>", "Open Recent File" },
		r = { "<cmd>Telescope registers<CR>", "Registers" },
		k = { "<cmd>Telescope keymaps<CR>", "Keymaps" },
		c = { "<cmd>Telescope commands<CR>", "Commands" },
	},

	t = {
		name = "Terminal",
		t = { "<cmd>lua _HTOP_TOGGLE()<CR>", "Htop" },
		f = { "<cmd>ToggleTerm direction=float<CR>", "Float" },
		h = { "<cmd>ToggleTerm size=10 direction=horizontal<CR>", "Horizontal" },
		v = { "<cmd>ToggleTerm size=80 direction=vertical<CR>", "Vertical" },
	},
}

local vopts = {
	mode = "v", -- VISUAL mode
	prefix = "<Leader>",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
}
local vmappings = {
	["/"] = { '<ESC><CMD>lua require("Comment.api").toggle_linewise_op(vim.fn.visualmode())<CR>', "Comment" },
}

which_key.setup(setup)
which_key.register(mappings, opts)
which_key.register(vmappings, vopts)
