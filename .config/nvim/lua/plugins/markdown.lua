return {
	-- Markdown Language Server (marksman)
	{
		"artempyanykh/marksman",
		ft = "markdown",
		config = function()
			-- This will be configured via lspconfig below
		end,
	},

	-- Enhanced Markdown syntax and features
	{
		"preservim/vim-markdown",
		ft = "markdown",
		config = function()
			-- Disable default key mappings
			vim.g.vim_markdown_no_default_key_mappings = 1

			-- Enable syntax highlighting for code blocks
			vim.g.vim_markdown_fenced_languages = {
				"html",
				"python",
				"javascript",
				"typescript",
				"lua",
				"bash=sh",
				"json",
				"yaml",
			}

			-- Table of contents settings
			vim.g.vim_markdown_toc_autofit = 1
			vim.g.vim_markdown_emphasis_multiline = 0

			-- Link settings
			vim.g.vim_markdown_follow_anchor = 1
			vim.g.vim_markdown_auto_insert_bullets = 1
			vim.g.vim_markdown_new_list_item_indent = 2

			-- Math support
			vim.g.vim_markdown_math = 1

			-- Frontmatter support
			vim.g.vim_markdown_frontmatter = 1
			vim.g.vim_markdown_toml_frontmatter = 1
			vim.g.vim_markdown_json_frontmatter = 1

			-- Concealing settings
			vim.g.vim_markdown_conceal = 2
			vim.g.vim_markdown_conceal_code_blocks = 0
		end,
	},

	-- Markdown preview
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = "markdown",
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
		config = function()
			-- Basic settings
			vim.g.mkdp_auto_start = 0
			vim.g.mkdp_auto_close = 1
			vim.g.mkdp_refresh_slow = 0
			vim.g.mkdp_command_for_global = 0
			vim.g.mkdp_open_to_the_world = 0
			vim.g.mkdp_open_ip = ""
			vim.g.mkdp_browser = ""
			vim.g.mkdp_echo_preview_url = 0
			vim.g.mkdp_browserfunc = ""

			-- Preview settings
			vim.g.mkdp_preview_options = {
				mkit = {},
				katex = {},
				uml = {},
				maid = {},
				disable_sync_scroll = 0,
				sync_scroll_type = "middle",
				hide_yaml_meta = 1,
				sequence_diagrams = {},
				flowchart_diagrams = {},
				content_editable = false,
				disable_filename = 0,
				toc = {},
			}

			-- Markdown CSS theme
			vim.g.mkdp_markdown_css = ""
			vim.g.mkdp_highlight_css = ""
			vim.g.mkdp_port = ""
			vim.g.mkdp_page_title = "「${name}」"
			vim.g.mkdp_filetypes = { "markdown" }
			vim.g.mkdp_theme = "dark"

			-- Custom keymaps for markdown preview
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "markdown",
				callback = function()
					vim.keymap.set(
						"n",
						"<leader>mp",
						":MarkdownPreviewToggle<CR>",
						{ buffer = true, desc = "Toggle Markdown Preview" }
					)
				end,
			})
		end,
	},

	-- Table mode for better table editing
	{
		"dhruvasagar/vim-table-mode",
		ft = "markdown",
		config = function()
			vim.g.table_mode_corner = "|"
			vim.g.table_mode_corner_corner = "+"
			vim.g.table_mode_header_fillchar = "="

			-- Enable table mode for markdown
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "markdown",
				callback = function()
					vim.keymap.set(
						"n",
						"<leader>tm",
						":TableModeToggle<CR>",
						{ buffer = true, desc = "Toggle Table Mode" }
					)
					vim.keymap.set(
						"n",
						"<leader>tr",
						":TableModeRealign<CR>",
						{ buffer = true, desc = "Realign Table" }
					)
				end,
			})
		end,
	},

	-- Improved list and checkbox handling
	{
		"bullets-vim/bullets.vim",
		ft = "markdown",
		config = function()
			vim.g.bullets_enabled_file_types = { "markdown", "text", "gitcommit" }
			vim.g.bullets_enable_in_empty_buffers = 0
			vim.g.bullets_set_mappings = 1
			vim.g.bullets_mapping_leader = ""
			vim.g.bullets_delete_last_bullet_if_empty = 1
			vim.g.bullets_line_spacing = 1

			-- Custom bullet points
			vim.g.bullets_custom_mappings = {
				["<CR>"] = ':call append(line("."), repeat(" ", indent(".")) . "- ")<CR>',
			}
		end,
	},
}
