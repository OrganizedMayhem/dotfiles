local methods = vim.lsp.protocol.Methods

return {
	name = "LSP",
	plugin = "snacks",
	icon = { icon = "\u{f121} ", color = "orange" },
	prefixes = { ["<leader>l"] = "lsp" },
	maps = {
		-- pickers (global, work once a server is attached)
		{ "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
		{ "gr", function() Snacks.picker.lsp_references() end, desc = "References", nowait = true },
		{ "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
		{ "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
		{ "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
		{ "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
		{ "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
		{ "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
		{ "gl", vim.diagnostic.open_float, desc = "Open Diagnostics in Float", plugin = "nvim" },

		-- buffer-local, set on LspAttach
		{ "gs", vim.lsp.buf.signature_help, desc = "Signature Documentation", lsp = true, plugin = "nvim" },
		{ "gD", vim.lsp.buf.declaration, desc = "Goto Declaration", lsp = true, plugin = "nvim" },
		{ "<leader>la", vim.lsp.buf.code_action, desc = "Code Action", lsp = true, plugin = "nvim" },
		{ "<leader>lr", vim.lsp.buf.rename, desc = "Rename all references", lsp = true, plugin = "nvim" },
		{ "<leader>lf", function() require("conform").format({ lsp_format = "fallback" }) end, desc = "Format", lsp = true, plugin = "conform" },
		{ "<leader>lc", vim.lsp.codelens.run, desc = "Run CodeLens", lsp = true, method = methods.textDocument_codeLens, plugin = "nvim" },
		{
			"<leader>v",
			function()
				vim.cmd.vsplit()
				vim.lsp.buf.definition()
			end,
			desc = "Goto Definition in Vertical Split",
			lsp = true,
			plugin = "nvim",
		},

		-- Neovim defaults (:h lsp-defaults)
		{ "K", desc = "Hover documentation", ref = true, plugin = "nvim" },
		{ "grn", desc = "Rename (shadowed by nowait gr)", ref = true, plugin = "nvim" },
		{ "gra", desc = "Code action (shadowed by nowait gr)", mode = { "n", "x" }, ref = true, plugin = "nvim" },
		{ "grr", desc = "References to quickfix (shadowed by nowait gr)", ref = true, plugin = "nvim" },
		{ "gri", desc = "Implementation (shadowed by nowait gr)", ref = true, plugin = "nvim" },
		{ "grt", desc = "Type definition (shadowed by nowait gr)", ref = true, plugin = "nvim" },
		{ "grx", desc = "Run codelens (shadowed by nowait gr)", ref = true, plugin = "nvim" },
		{ "gO", desc = "Document symbols", ref = true, plugin = "nvim" },
		{ "<C-s>", desc = "Signature help", mode = "i", ref = true, plugin = "nvim" },
		{ "<C-w>d", desc = "Diagnostic float", ref = true, plugin = "nvim" },
	},
}
