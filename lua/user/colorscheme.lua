local colorscheme = "onedark"

local status_ok, theme = pcall(require, colorscheme)
if not status_ok then
	vim.notify("colorscheme " .. colorscheme .. " not found!")
	return
end

theme.setup({
	style = "cool", -- Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
	transparent = false, -- Show/hide background
	term_colors = true, -- Change terminal color as per the selected theme style
	ending_tildes = false, -- Show the end-of-buffer tildes. By default they are hidden
	cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu

	-- toggle theme style ---
	toggle_style_key = "<leader>ts", -- Default keybinding to toggle
	toggle_style_list = { "dark", "darker", "cool", "deep", "warm", "warmer", "light" }, -- List of styles to toggle between

	-- Change code style ---
	-- Options are italic, bold, underline, none
	-- You can configure multiple style with comma separated, For e.g., keywords = 'italic,bold'
	code_style = {
		comments = "italic",
		keywords = "none",
		functions = "none",
		strings = "none",
		variables = "none",
	},

	-- Custom Highlights --
	-- Override default colors
	colors = {
		-- bright_orange = "#ff8800", -- define a new color
		-- green = "#00ffaa", -- redefine an existing color
	},
	-- Override highlight groups
	highlights = {
		-- darker = true, -- darker colors for diagnostic
		-- undercurl = true, -- use undercurl instead of underline for diagnostics
		-- background = true,  -- use background color for virtual text
	},

	-- Plugins Config --
	diagnostics = {
		darker = true, -- darker colors for diagnostic
		undercurl = true, -- use undercurl instead of underline for diagnostics
		background = true, -- use background color for virtual text
	},
})
theme.load()
