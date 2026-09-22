vim.keymap.set("n", "-", "<cmd>Oil --float<CR>", { desc = "Open Parent Directory in Oil" })
vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Open Diagnostics in Float" })

vim.keymap.set("n", "<leader>cf", function()
	require("conform").format({
		lsp_format = "fallback",
	})
end, { desc = "Format current file" })

vim.keymap.set("n", "<leader>fp", "<cmd>ProjectFzf<CR>", { silent = true, desc = "Find Projects" })

-- 0.12 built-in plugins
vim.keymap.set("n", "<leader>U", function()
	vim.cmd.packadd("nvim.undotree")
	vim.cmd.Undotree()
end, { desc = "Toggle Undotree" })
