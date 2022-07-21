local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.keymap.set

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --

-- Open terminal in split window
keymap("n", "<Leader>vst", ":vsplit term://zsh<CR>", opts)
keymap("n", "<Leader>hst", ":split term://zsh<CR>", opts)

-- Resize window with arrows
keymap("n", "<C-Up>", ":resize +2<CR>", opts)
keymap("n", "<C-Down>", ":resize -2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Insert --
-- Press jk fast to enter
keymap("i", "jk", "<ESC>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)
keymap("v", "p", '"_dP', opts) -- change default yank/paste behavior

-- Visual Block --
-- Move text up and down
keymap("x", "<S-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<S-k>", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Gitsigns
local gs_ok, gs = pcall(require, "gitsigns")
if not gs_ok then
	vim.notify("failed to load gitsigns")
	return
end

local function gs_keymap(mode, l, r, gs_opts)
	gs_opts = gs_opts or {}
	gs_opts.buffer = 0
	keymap(mode, l, r, gs_opts)
end

gs_keymap("n", "]c", function()
	if vim.wo.diff then
		return "]c"
	end
	vim.schedule(function()
		gs.next_hunk()
	end)
	return "<Ignore>"
end, { expr = true })

gs_keymap("n", "[c", function()
	if vim.wo.diff then
		return "[c"
	end
	vim.schedule(function()
		gs.prev_hunk()
	end)
	return "<Ignore>"
end, { expr = true })

-- Ultra folding
local openAllAndRefresh = function()
	require("ufo").openAllFolds()
	vim.cmd([[ IndentBlanklineRefresh ]])
end
-- toggle folding with refresh indent guides
keymap("n", "za", function()
	vim.cmd([[ exe 'normal! za'.(foldlevel('.')?'':'l') ]])
	vim.cmd([[ IndentBlanklineRefresh ]])
end, opts)
-- close folding with refresh indent guides
keymap("n", "zc", function()
	vim.cmd([[ exe 'normal! zc'.(foldlevel('.')?'':'l') ]])
	vim.cmd([[ IndentBlanklineRefresh ]])
end, opts)
-- open folding with refresh indent guides
keymap("n", "zo", function()
	vim.cmd([[ exe 'normal! zo'.(foldlevel('.')?'':'l') ]])
	vim.cmd([[ IndentBlanklineRefresh ]])
end, opts)
keymap("n", "zR", openAllAndRefresh, opts)
keymap("n", "zM", require("ufo").closeAllFolds, opts)
keymap("n", "zK", function()
	local winid = require("ufo").peekFoldedLinesUnderCursor()
	if not winid then
		-- nvimlsp
		vim.lsp.buf.hover()
	end
end, opts)
