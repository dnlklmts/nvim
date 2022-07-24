-- https://github.com/mfussenegger/nvim-dap
local ok, dap = pcall(require, "dap")
if not ok then
	return
end

-- https://github.com/mfussenegger/nvim-dap/blob/master/doc/dap.txt#L365
dap.defaults.fallback.external_terminal = {
	command = "/usr/bin/alacritty",
	args = { "-e" },
}
dap.defaults.fallback.force_external_terminal = true
dap.defaults.fallback.focus_terminal = true
dap.set_log_level("TRACE")

-- https://github.com/mfussenegger/nvim-dap/blob/master/doc/dap.txt#L45
dap.adapters.delve = {
	type = "server",
	port = "38697",
	executable = {
		command = "/home/kurisumasu/.local/bin/dlv",
		args = { "dap", "--check-go-version", "false", "--listen", "127.0.0.1:38697", "--log-dest", "3" },
	},
}

-- https://github.com/mfussenegger/nvim-dap/blob/master/doc/dap.txt#L185
-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#go-using-delve-directly
-- Borrowed heavily from https://github.com/leoluz/nvim-dap-go/blob/main/lua/dap-go.lua
dap.configurations.go = {
	-- Current file
	{
		type = "delve",
		name = "Debug File",
		request = "launch",
		-- mode = "debug",
		program = "${file}",
	},
	--  Current package
	{
		type = "delve",
		name = "Debug Package",
		request = "launch",
		program = "${fileDirname}",
	},
	-- Current working directory
	{
		type = "delve",
		name = "Debug Project",
		request = "launch",
		-- mode = "debug",
		program = "${workspaceFolder}",
	},
	-- Current working directory (cmd/main.go)
	{
		type = "delve",
		name = "Debug Project (cmd/main.go)",
		request = "launch",
		-- mode = "debug",
		program = "${workspaceFolder}/cmd",
	},
	-- Tests at the current file
	{
		type = "go",
		name = "Debug Test",
		request = "launch",
		mode = "test",
		program = "${file}",
	},
	-- Tests at the project
	{
		type = "go",
		name = "Debug Test (go.mod)",
		request = "launch",
		mode = "test",
		program = "./${relativeFileDirname}",
	},
}

vim.highlight.create("DapBreakpoint", { ctermbg = 0, guifg = "#993939", guibg = "#31353f" }, false)
vim.highlight.create("DapLogPoint", { ctermbg = 0, guifg = "#61afef", guibg = "#31353f" }, false)
vim.highlight.create("DapStopped", { ctermbg = 0, guifg = "#98c379", guibg = "#31353f" }, false)

vim.fn.sign_define(
	"DapBreakpoint",
	{ text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
)
vim.fn.sign_define(
	"DapBreakpointCondition",
	{ text = "ﳁ", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
)
vim.fn.sign_define(
	"DapBreakpointRejected",
	{ text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
)
vim.fn.sign_define(
	"DapLogPoint",
	{ text = "", texthl = "DapLogPoint", linehl = "DapLogPoint", numhl = "DapLogPoint" }
)
vim.fn.sign_define("DapStopped", { text = "", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" })
