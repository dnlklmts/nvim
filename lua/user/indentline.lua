local status_ok, indentline = pcall(require("indent_blankline"))
if not status_ok then
	return
end

vim.opt.list = true
indentline.setup({
	space_char_blankline = " ",
	show_current_context = true,
	show_current_context_start = true,
})
