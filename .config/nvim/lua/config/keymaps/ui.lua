return {
	name = "UI",
	plugin = "snacks",
	icon = { icon = "\u{f0675} ", color = "cyan" },
	prefixes = { ["<leader>u"] = "ui" },
	maps = {
		{ "<leader>us", toggle = function() return Snacks.toggle.option("spell", { name = "Spelling" }) end, desc = "Toggle Spelling" },
		{ "<leader>uw", toggle = function() return Snacks.toggle.option("wrap", { name = "Wrap" }) end, desc = "Toggle Wrap" },
		{ "<leader>uL", toggle = function() return Snacks.toggle.option("relativenumber", { name = "Relative Number" }) end, desc = "Toggle Relative Number" },
		{ "<leader>ul", toggle = function() return Snacks.toggle.line_number() end, desc = "Toggle Line Numbers" },
		{ "<leader>ud", toggle = function() return Snacks.toggle.diagnostics() end, desc = "Toggle Diagnostics" },
		{
			"<leader>uc",
			toggle = function()
				return Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
			end,
			desc = "Toggle Conceal",
		},
		{ "<leader>uT", toggle = function() return Snacks.toggle.treesitter() end, desc = "Toggle Treesitter" },
		{
			"<leader>ub",
			toggle = function()
				return Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" })
			end,
			desc = "Toggle Dark Background",
		},
		{ "<leader>uh", toggle = function() return Snacks.toggle.inlay_hints() end, desc = "Toggle Inlay Hints" },
		{ "<leader>ug", toggle = function() return Snacks.toggle.indent() end, desc = "Toggle Indent Guides" },
		{ "<leader>uD", toggle = function() return Snacks.toggle.dim() end, desc = "Toggle Dim" },
		{ "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
		{ "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
		{ "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },
		{ "<leader>Z", function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },
	},
}
