-- In your plugin specification file (e.g., ~/.config/nvim/lua/plugins/lsp.lua)
return {
	-- LSP Configuration
	{
		"neovim/nvim-lspconfig",
		lazy = true,
		dependencies = {
			-- Automatically install LSPs and related tools to stdpath for Neovim
			"mason-org/mason.nvim",
			"mason-org/mason-lspconfig.nvim",
		},
		config = function()
			-- Setup mason to manage LSP servers automatically
			require("mason").setup()
			require("mason-lspconfig").setup({
				-- Ensure these servers are automatically installed and setup
				ensure_installed = { "ruff_lsp" },
			})

			-- Configure ruff-lsp
			-- See: https://github.com/astral-sh/ruff-lsp
			require("lspconfig").ruff_lsp.setup({
				init_options = {
					settings = {
						-- Any extra CLI arguments for `ruff` go here
						args = {},
					},
				},
				on_attach = function(client, bufnr)
					-- If you're using ruff alongside other Python LSPs (like Pyright),
					-- you may want to disable certain capabilities in ruff-lsp

					-- For example, to disable hover in favor of Pyright's hover:
					-- client.server_capabilities.hoverProvider = false

					-- Setup keybindings for LSP functionality
					local opts = { noremap = true, silent = true, buffer = bufnr }
					vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, opts)
					vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
				end,
			})
		end,
	},

	-- Optional: Add this plugin for ruff-lsp
	{
		"astral-sh/ruff-lsp",
		ft = { "python" }, -- Only load for Python files
	},
}
