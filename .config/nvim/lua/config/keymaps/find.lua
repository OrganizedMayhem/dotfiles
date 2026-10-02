local function fzf(name)
	return function()
		require("fzf-lua")[name]()
	end
end

return {
	name = "Find",
	plugin = "snacks",
	icon = { icon = "\u{f002} ", color = "green" },
	prefixes = { ["<leader>f"] = "find" },
	maps = {
		{ "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
		{ "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
		{ "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
		{ "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
		{ "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
		{ "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
		{ "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
		{ "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },
		{ "-", "<cmd>Oil --float<CR>", desc = "Open Parent Directory in Oil", plugin = "oil" },
		{ "<leader>fp", "<cmd>ProjectFzf<CR>", desc = "Find Projects", silent = true, plugin = "project-fzf" },
		{ "<leader>fo", fzf("oldfiles"), desc = "Find Old Files", plugin = "fzf-lua" },
		{ "<leader>fh", fzf("helptags"), desc = "Find Help", plugin = "fzf-lua" },
		{ "<leader>fk", fzf("keymaps"), desc = "Find Keymaps", plugin = "fzf-lua" },
		{ "<leader>fw", fzf("grep_cword"), desc = "Find current Word", plugin = "fzf-lua" },
		{ "<leader>fW", fzf("grep_cWORD"), desc = "Find current WORD", plugin = "fzf-lua" },
		{ "<leader>fd", fzf("diagnostics_document"), desc = "Find Diagnostics", plugin = "fzf-lua" },
	},
}
