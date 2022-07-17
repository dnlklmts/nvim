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
-- Open file explorer
-- keymap("n", "<Leader>e", ":Lex 30<CR>", opts)
keymap("n", "<Leader>l", ":nohl<CR>", opts)

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

-- Telescope shortcuts
local tsbuiltin = require("telescope.builtin")
local tsthemes = require("telescope.themes")

keymap("n", "<Leader>p", function()
	return tsbuiltin.find_files(tsthemes.get_dropdown({
		previewer = false,
		winblend = 10,
	}))
end)

keymap("n", "<Leader>f", tsbuiltin.live_grep)

keymap("n", "<Leader>gr", function()
	return tsbuiltin.lsp_references(tsthemes.get_cursor({
		winblend = 10,
	}))
end)
keymap("n", "<Leader>gp", ":Telescope projects<CR>", opts)

-- Nvim Tree
keymap("n", "<Leader>e", ":NvimTreeToggle<CR>", opts)
keymap("n", "<Leader>q", ":Bdelete %<CR>", opts)
keymap("n", "<Leader>qa", ":bufdo :Bdelete<CR>", opts)

-- Ultra folding
keymap("n", "zR", require("ufo").openAllFolds)
keymap("n", "zM", require("ufo").closeAllFolds)
keymap("n", "zK", function()
	local winid = require("ufo").peekFoldedLinesUnderCursor()
	if not winid then
		-- nvimlsp
		vim.lsp.buf.hover()
	end
end)

-- Gitsigns
local gs_ok, gs = pcall(require, "gitsigns")
if not gs_ok then
	vim.notify("failed to load gitsigns")
	return
end

local function gs_keymap(mode, l, r, gs_opts)
	gs_opts = gs_opts or {}
	gs_opts.buffer = bufnr
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

gs_keymap({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>")
gs_keymap({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>")
gs_keymap("n", "<leader>hS", gs.stage_buffer)
gs_keymap("n", "<leader>hu", gs.undo_stage_hunk)
gs_keymap("n", "<leader>hR", gs.reset_buffer)
gs_keymap("n", "<leader>hp", gs.preview_hunk)
gs_keymap("n", "<leader>hb", function()
	gs.blame_line({ full = true })
end)
gs_keymap("n", "<leader>tb", gs.toggle_current_line_blame)
gs_keymap("n", "<leader>hd", gs.diffthis)
gs_keymap("n", "<leader>hD", function()
	gs.diffthis("~")
end)
gs_keymap("n", "<leader>td", gs.toggle_deleted)

gs_keymap({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
