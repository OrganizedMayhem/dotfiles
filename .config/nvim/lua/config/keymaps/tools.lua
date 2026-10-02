return {
	name = "Tools",
	plugin = "snacks",
	icon = { icon = "\u{f0ad} ", color = "purple" },
	prefixes = { ["<leader>b"] = "buffer" },
	maps = {
		{ "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
		{ "<leader>.", function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
		{ "<leader>S", function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
		{ "<c-/>", function() Snacks.terminal() end, desc = "Toggle Terminal" },
		{ "<c-_>", function() Snacks.terminal() end, desc = "Toggle Terminal", hidden = true },
		{
			"<leader>N",
			function()
				Snacks.win({
					file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
					width = 0.6,
					height = 0.6,
					wo = {
						spell = false,
						wrap = false,
						signcolumn = "yes",
						statuscolumn = " ",
						conceallevel = 3,
					},
				})
			end,
			desc = "Neovim News",
		},
		{
			"<leader>U",
			function()
				vim.cmd.packadd("nvim.undotree")
				vim.cmd.Undotree()
			end,
			desc = "Toggle Undotree",
			plugin = "nvim",
		},
		{ "<leader>?", function() require("which-key").show({ global = true }) end, desc = "All Keymaps (which-key)", plugin = "which-key" },
	},
}
