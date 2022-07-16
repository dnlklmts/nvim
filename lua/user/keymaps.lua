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

-- Terminal --
-- Better terminal navigation
-- keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
-- keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
-- keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
-- keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)

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
