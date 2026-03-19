-- Load custom LSP server configurations
local function load_server_config(server_name)
	local ok, config = pcall(require, "lsp." .. server_name)
	if ok then
		return config
	end
	return {}
end

-- Configure and enable LSP servers with custom settings
local servers = { "gopls", "lua_ls", "ty", "terraform-ls" }

for _, server_name in ipairs(servers) do
	local config = load_server_config(server_name)
	vim.lsp.enable(server_name, config)
end

vim.diagnostic.config({
	virtual_lines = true,
	-- virtual_text = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = true,
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅚 ",
			[vim.diagnostic.severity.WARN] = "󰀪 ",
			[vim.diagnostic.severity.INFO] = "󰋽 ",
			[vim.diagnostic.severity.HINT] = "󰌶 ",
		},
		numhl = {
			[vim.diagnostic.severity.ERROR] = "ErrorMsg",
			[vim.diagnostic.severity.WARN] = "WarningMsg",
		},
	},
})
