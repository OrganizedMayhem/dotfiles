-- ~/.config/nvim/lua/plugins/treesitter.lua (or similar)

return {
	-- Nvim-treesitter itself
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate", -- Ensure parsers are updated on install/update
		event = { "BufReadPre", "BufNewFile" },
		-- Make sure you're using the 'main' branch for nvim-treesitter
		-- If your plugin manager doesn't default to main, specify it:
		-- branch = "main",
		config = function()
			require("nvim-treesitter.config").setup({
				-- Highlight is essential for treesitter to function visually
				highlight = {
					enable = true,
					-- Disable these if you encounter performance issues or prefer other highlighting
					-- disable = { "c", "cpp" }, -- Example: disable highlight for C and C++
					-- You can also specify certain contexts where highlight should be disabled
					-- scm_context = false, -- Disable highlight for SCM (source control management) context
				},
				-- Indent uses treesitter for smart indentation
				indent = {
					enable = true,
				},
				-- Enable textobjects module here
				textobjects = {
					select = {
						enable = true,
						-- Automatically jump forward to textobj, similar to targets.vim lookahead
						lookahead = true,
						keymaps = {
							-- You can use the capture groups defined in textobjects.scm
							-- For example, to select a function:
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							-- To select a class:
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
							-- Other useful text objects:
							["aa"] = "@parameter.outer", -- function arguments/parameters
							["ia"] = "@parameter.inner",
							["al"] = "@loop.outer", -- loop block
							["il"] = "@loop.inner",
							["ab"] = "@block.outer", -- generic block
							["ib"] = "@block.inner",
							["ap"] = "@call.outer", -- function call
							["ip"] = "@call.inner",
							["as"] = "@statement.outer", -- statement
							["is"] = "@statement.inner",
							["ad"] = "@conditional.outer", -- conditional (if/else)
							["id"] = "@conditional.inner",
							["ae"] = "@comment.outer", -- comments
							["ie"] = "@comment.inner",
							-- You can define more custom keymaps based on the available queries
						},
						-- You can also specify selection modes (e.g., 'v' for charwise, 'V' for linewise)
						-- This is useful for making text objects act like visual line selections
						selection_modes = {
							["@parameter.outer"] = "v",
							["@function.outer"] = "V",
							["@class.outer"] = "V",
						},
					},
					move = {
						enable = true,
						set_jumps = true, -- whether to set jumps in the jumplist
						goto_next_start = {
							["]m"] = "@function.outer",
							["]]"] = "@class.outer",
						},
						goto_next_end = {
							["]M"] = "@function.outer",
							["']["] = "@class.outer", -- Example: using '][ for next class end
						},
						goto_previous_start = {
							["[m"] = "@function.outer",
							["[["] = "@class.outer",
						},
						goto_previous_end = {
							["[M"] = "@function.outer",
							["[']"] = "@class.outer", -- Example: using '['] for previous class end
						},
					},
					swap = {
						enable = true,
						swap_next = {
							["<leader>a"] = "@parameter.outer",
							["<leader>s"] = "@call.outer",
						},
						swap_previous = {
							["<leader>A"] = "@parameter.outer",
							["<leader>S"] = "@call.outer",
						},
					},
					-- lsp_interop: allows textobjects to peek at LSP definitions
					lsp_interop = {
						enable = true,
						border = "rounded",
						floating_preview_opts = {},
						peek_definition_code = {
							["<leader>lo"] = { query = "@class.outer", desc = "Peek class" },
							["<leader>lp"] = { query = "@function.outer", desc = "Peek function" },
						},
					},
				},
			})
		end,
	},
	-- Nvim-treesitter-textobjects plugin
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		-- Important: ensure it loads after nvim-treesitter
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		-- Make sure you're also on the 'main' branch for textobjects
		-- branch = "main",
	},
}

