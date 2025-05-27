-- ~/.config/nvim/lua/plugins/snacks.lua
-- This file assumes you are using lazy.nvim and have it set up to load plugins
-- from the `plugins` directory.

return {
	{
		"folke/snacks.nvim",
		-- Set to true to load snacks.nvim on startup. If false, individual snacks
		-- will be loaded on demand when their functions are called.
		lazy = false,
		priority = 1000, -- Often a good idea to load QoL plugins early

		opts = {
			-- General configuration for snacks.nvim itself, though most config
			-- happens within individual snack tables.

			-- animate: Efficient animations with easing functions.
			animate = {
				enabled = true, -- Enable/disable the animation library
				-- You can configure default animation options here, like duration, easing function, etc.
				-- These are library-level settings, not specific to a visual animation.
				-- For example:
				-- duration = 200, -- in milliseconds
				-- easing = "linear", -- e.g., "easeOutQuad", "easeInOutCubic", etc.
			},

			-- bigfile: Deal with big files.
			bigfile = {
				enabled = true, -- Enable/disable bigfile handling
				size = 1024 * 1024, -- File size in bytes (default 1MB) after which bigfile warnings/optimizations apply
				-- Set filetype-specific options for big files
				filetype = {
					markdown = {
						disable_lsp = true,
						disable_treesitter = true,
					},
					-- Add more filetypes here as needed
				},
			},

			-- bufdelete: Delete buffers without disrupting window layout.
			bufdelete = {
				enabled = true, -- Enable/disable buffer deletion utility
				prompt_save = true, -- Prompt to save unsaved changes before deleting
				-- Hook to run after a buffer is deleted
				on_delete = function(bufnr)
					-- print(string.format("Buffer %d deleted!", bufnr))
				end,
			},

			-- dashboard: Beautiful declarative dashboards.
			dashboard = {
				enabled = true, -- Enable/disable the dashboard
				theme = "hyper", -- "hyper", "alpha", "minimal", or your custom theme
				section_padding = 0, -- Padding between sections
				shortcut_layout = "horizontal", -- "horizontal" or "vertical" for shortcuts
				buttons = {
					-- Example buttons, customize as needed
					{ "f", "󰈔 Find file", [[<cmd>Snacks.picker.files()<CR>]] },
					{ "n", "󰈛 New file", [[<cmd>enew<CR>]] },
					{ "r", "󰗀 Recent files", [[<cmd>Snacks.picker.recent()<CR>]] },
					{ "g", " Grep", [[<cmd>Snacks.picker.live_grep()<CR>]] },
					{ "s", "󰒓 Session", [[<cmd>Snacks.picker.sessions()<CR>]] },
					{ "q", "󰅙 Quit", [[<cmd>qa<CR>]] },
				},
				footer = " ", -- Optional footer text
			},

			-- debug: Pretty inspect & backtraces for debugging.
			debug = {
				enabled = true, -- Enable/disable debug utilities
				-- No specific configuration options commonly exposed beyond enabling/disabling
			},

			-- dim: Focus on the active scope by dimming the rest.
			dim = {
				enabled = true, -- Enable/disable dimming
				alpha = 0.3, -- Alpha value for dimming (0.0 to 1.0)
				excluded_filetypes = { "NvimTree", "lazy", "packer", "alpha", "dashboard" }, -- Filetypes not to dim
				-- Highlight groups for dimmed elements
				hl = {
					Normal = { fg = "#3e424a" }, -- Dimmed normal text
					LineNr = { fg = "#3e424a" }, -- Dimmed line numbers
					CursorLineNr = { fg = "#6e727a" }, -- Dimmed cursor line number
					-- Add more highlight groups to dim as needed
				},
			},

			-- explorer: A file explorer (picker in disguise).
			explorer = {
				enabled = true, -- Enable/disable the explorer
				replace_netrw = true, -- Replace netrw when opening directories
				-- Configuration for the underlying picker
				win = {
					-- See picker.win options for more details
					border = "rounded",
					title = "Explorer",
				},
				-- Configuration for the source within the picker
				sources = {
					explorer = {
						show_hidden = true, -- Show hidden files
						show_icons = true, -- Show file icons (requires nvim-web-devicons or similar)
						group_directories = true, -- Group directories at the top
						sort_by = "name", -- "name", "size", "mtime"
						-- Custom actions for explorer items
						actions = {
							-- Define custom actions here, e.g.,
							-- ["<CR>"] = "select_default",
							-- ["<C-t>"] = "open_tab",
							-- ["<C-v>"] = "open_vsplit",
							-- ["<C-s>"] = "open_split",
						},
					},
				},
			},

			-- git: Git utilities.
			git = {
				enabled = true, -- Enable/disable git utilities
				-- No specific configuration options commonly exposed beyond enabling/disabling
				-- It provides functions like `Snacks.git.hunks()`, `Snacks.git.blame()`, etc.
			},

			-- gitbrowse: Open the current file, branch, commit, or repo in a browser.
			gitbrowse = {
				enabled = true, -- Enable/disable gitbrowse
				-- No specific configuration options commonly exposed beyond enabling/disabling
				-- It uses the default git remote configuration.
			},

			-- image: Image viewer using Kitty Graphics Protocol, Wezterm, or Ghostty.
			image = {
				enabled = true, -- Enable/disable image rendering
				backend = "kitty", -- "kitty", "wezterm", "ghostty", "auto"
				-- Minimum width/height for inline images in characters
				min_width = 8,
				min_height = 4,
				-- Maximum width/height for inline images
				max_width = 80,
				max_height = 40,
				-- Path to external image conversion tool (e.g., ImageMagick's `magick` or `convert`)
				converter = "magick",
				-- Path to external PDF rendering tool (e.g., `gs` from Ghostscript)
				pdf_renderer = "gs",
				-- Path to external LaTeX rendering tool (e.g., `tectonic` or `pdflatex`)
				latex_renderer = "tectonic",
				-- Path to external Mermaid rendering tool (e.g., `mmdc` from Mermaid CLI)
				mermaid_renderer = "mmdc",
				-- Filetypes where inline images should be enabled
				filetypes = { "markdown", "neorg", "typst", "latex" },
				-- Whether to hide images when `concealcursor` is active
				hide_on_concealcursor = true,
			},

			-- indent: Indent guides and scopes.
			indent = {
				enabled = true, -- Enable/disable indent guides
				indent = {
					char = "│", -- Character for indent guides
					-- Highlight group for indent guides
					hl = "SnacksIndentGuide", -- Defaults to `SnacksIndentGuide`
				},
				scope = {
					enabled = true, -- Enable/disable indent scopes
					char = "▎", -- Character for scope line
					-- Highlight group for scope line
					hl = "SnacksIndentScope", -- Defaults to `SnacksIndentScope`
					-- Whether to only show the scope for the current line
					only_current = true,
					-- Whether to show the scope for the current line only in normal mode
					only_current_normal = false,
					-- Show scope lines for empty lines
					show_empty = true,
				},
				-- Exclude specific filetypes from indent guides
				excluded_filetypes = { "TelescopePrompt", "lazy", "NvimTree", "packer" },
			},

			-- input: Better vim.ui.input.
			input = {
				enabled = true, -- Enable/disable enhanced input
				-- No specific configuration options commonly exposed beyond enabling/disabling
				-- It provides functions like `Snacks.input()` which replaces `vim.ui.input`.
			},

			-- layout: Window layouts.
			layout = {
				enabled = true, -- Enable/disable window layout management
				-- Default layout to restore on startup (e.g., "default", "saved_layout_name")
				-- default_layout = "default",
				-- Options for saving/loading layouts
				save_on_exit = true, -- Save current layout when Neovim exits
				load_on_startup = true, -- Load last saved layout on startup
				-- Directory to store layout files
				directory = vim.fn.stdpath("data") .. "/snacks/layouts",
			},

			-- lazygit: Open LazyGit in a float, auto-configure colorscheme and integration.
			lazygit = {
				enabled = true, -- Enable/disable LazyGit integration
				float_opts = {
					border = "rounded",
					width = 0.9,
					height = 0.9,
					-- Other float window options (e.g., `row`, `col`, `focusable`)
				},
				-- Whether to automatically set LazyGit's colorscheme to match Neovim's
				auto_colorscheme = true,
			},

			-- notifier: Pretty vim.notify.
			notifier = {
				enabled = true, -- Enable/disable enhanced notifications
				-- Default notification options (can be overridden per notification)
				defaults = {
					timeout = 5000, -- milliseconds
					-- vim.log.levels.INFO, WARN, ERROR, DEBUG
					level = vim.log.levels.INFO,
					-- Position for messages: "top", "bottom", "left", "right", "center"
					-- Or a table { row = <num>, col = <num> } for fixed position
					position = "top",
					-- Styling for the notification window
					win_options = {
						border = "single",
						wrap = true,
						-- Add more win options as needed
					},
					-- Highlight groups for different notification levels
					highlights = {
						INFO = "SnacksNotifyInfo",
						WARN = "SnacksNotifyWarn",
						ERROR = "SnacksNotifyError",
						DEBUG = "SnacksNotifyDebug",
					},
				},
			},

			-- picker: Picker for selecting items.
			picker = {
				enabled = true, -- Enable/disable the picker utility
				win = {
					-- Options for the picker window
					width = 0.8, -- Relative width
					height = 0.8, -- Relative height
					min_width = 60,
					min_height = 20,
					max_width = 120,
					max_height = 40,
					row = nil, -- Y position (nil for center)
					col = nil, -- X position (nil for center)
					border = "rounded", -- "none", "single", "double", "rounded", "solid", "shadow"
					-- Highlight group for the border
					border_hl = "SnacksPickerBorder",
					-- Background highlight for the window
					win_hl = "SnacksPickerNormal",
					-- Custom window options, e.g., `noautocmd`, `wrap`, etc.
					options = {},
					-- Input window options (part of the picker window)
					input = {
						height = 1,
						border = "rounded",
						-- Highlight group for the input border
						border_hl = "SnacksPickerInputBorder",
						-- Highlight group for the input window
						win_hl = "SnacksPickerInput",
						prompt = "> ", -- Prompt text
						-- Keymaps specific to the picker input window
						keys = {
							-- Default keymaps are usually good, but you can override or add
							-- ["<C-j>"] = "move_selection_next",
							-- ["<C-k>"] = "move_selection_prev",
							-- ["<CR>"] = "confirm_selection",
							-- ["<Esc>"] = "close_picker",
						},
					},
					-- List window options (part of the picker window)
					list = {
						border = "rounded",
						-- Highlight group for the list border
						border_hl = "SnacksPickerListBorder",
						-- Highlight group for the list window
						win_hl = "SnacksPickerList",
						preview_height = 0, -- Set to 0 to disable preview
						-- Highlight group for selected item
						selection_hl = "SnacksPickerSelection",
						-- Highlight group for matched text in items
						match_hl = "SnacksPickerMatch",
					},
					-- Preview window options (part of the picker window)
					preview = {
						enabled = true, -- Enable/disable preview
						width = 0.6, -- Relative width of preview area
						-- Highlight group for the preview border
						border_hl = "SnacksPickerPreviewBorder",
						-- Highlight group for the preview window
						win_hl = "SnacksPickerPreview",
						-- Custom preview window options
						options = {
							wrap = true,
							number = false,
							relativenumber = false,
							signcolumn = "no",
						},
					},
				},
				-- Default actions available in the picker
				actions = {
					-- Define custom actions or override defaults
					-- Example:
					-- close_picker = function(picker) picker:close() end,
					-- confirm_selection = function(picker) picker:confirm() end,
				},
				-- Default sources for the picker (e.g., "files", "buffers", "grep")
				-- These are the functions like `Snacks.picker.files()`, `Snacks.picker.buffers()`, etc.
				sources = {
					-- You can configure individual source behaviors here
					files = {
						root = nil, -- Start searching from project root (nil) or current working directory (vim.fn.getcwd())
						show_hidden = false,
						show_icons = true,
						ignore_patterns = { "%.git/", "node_modules/" },
					},
					buffers = {
						hidden = false, -- Show hidden buffers
						nofile = false, -- Show nofile buffers
					},
					live_grep = {
						-- Options passed to `vim.fn.system` for grep command
						args = { "rg", "--column", "--line-number", "--no-heading", "--color=always", "--smart-case" },
						-- Patterns to ignore
						ignore_patterns = { "%.git/", "node_modules/" },
					},
					-- ... other sources like `recent`, `commands`, `keymaps`, `marks`, `qflist`, `loclist`, etc.
				},
			},

			-- profiler: Neovim Lua profiler.
			profiler = {
				enabled = true, -- Enable/disable the profiler (usually disabled by default)
				-- Output path for profiling results
				output_path = vim.fn.stdpath("cache") .. "/snacks/profile.txt",
				-- Max stack depth to record for profiling
				max_depth = 20,
				-- How often to sample (in milliseconds)
				interval = 1,
			},

			-- quickfile: Render file quickly before loading plugins.
			quickfile = {
				enabled = true, -- Enable/disable quickfile rendering
				-- No specific configuration options commonly exposed beyond enabling/disabling
				-- This mostly affects startup behavior.
			},

			-- rename: LSP-integrated file renaming.
			rename = {
				enabled = true, -- Enable/disable LSP-integrated renaming
				-- Whether to prompt for confirmation before renaming linked files
				prompt_confirm = true,
				-- Integrate with file explorers (e.g., 'neo-tree.nvim', 'mini.files')
				-- Set to `true` to auto-detect or specify a list of supported explorers
				explorer_integration = true,
			},

			-- scope: Scope detection, text objects and jumping based on treesitter or indent.
			scope = {
				enabled = true, -- Enable/disable scope features
				-- Treesitter-based scope options
				treesitter = {
					enabled = true,
					-- Query files for different languages (e.g., "lua", "javascript", "typescript")
					-- Snacks uses default queries, but you can specify custom ones if needed.
				},
				-- Indent-based scope options (fallback if treesitter isn't available or preferred)
				indent = {
					enabled = true,
					-- No specific configuration options commonly exposed beyond enabling/disabling
				},
				-- Whether to highlight the current scope
				highlight_current_scope = true,
				-- Highlight group for the current scope
				current_scope_hl = "SnacksScope",
			},

			-- scratch: Scratch buffers with a persistent file.
			scratch = {
				enabled = true, -- Enable/disable scratch buffers
				-- Directory to store scratch files
				directory = vim.fn.stdpath("data") .. "/snacks/scratch",
				-- Default filetype for new scratch buffers
				default_filetype = "text",
				-- Template for new scratch files (can be a function or a string)
				template = function()
					return string.format("-- New Scratch Buffer - %s\n\n", os.date("%Y-%m-%d %H:%M:%S"))
				end,
				-- Whether to close the scratch buffer when Neovim exits
				close_on_exit = false,
				-- Max number of scratch files to keep (oldest will be deleted)
				max_files = 100,
			},

			-- scroll: Smooth scrolling.
			scroll = {
				enabled = true, -- Enable/disable smooth scrolling
				-- Duration of the scroll animation in milliseconds
				duration = 100,
				-- Easing function for scrolling (e.g., "linear", "easeOutQuad")
				easing = "easeOutQuad",
				-- Whether to scroll vertically
				vertical = true,
				-- Whether to scroll horizontally
				horizontal = true,
			},

			-- statuscolumn: Pretty status column.
			statuscolumn = {
				enabled = true, -- Enable/disable pretty status column
				-- Whether to show line numbers
				number = true,
				-- Whether to show relative line numbers
				relativenumber = true,
				-- Whether to show sign column (for LSP diagnostics, git signs, etc.)
				signcolumn = "yes", -- "yes", "no", "auto"
				-- Whether to show folding markers
				foldcolumn = "auto", -- "auto", "0", "1", etc.
				-- Highlight group for line numbers
				number_hl = "LineNr",
				-- Highlight group for relative line numbers
				relativenumber_hl = "CursorLineNr",
				-- Highlight group for fold column
				foldcolumn_hl = "FoldColumn",
				-- Highlight group for sign column
				signcolumn_hl = "SignColumn",
				-- Customize rendering function for each part of the status column
				-- Example (defaults are usually good):
				-- render_number = function(line_nr) return string.format("%4d", line_nr) end,
				-- render_relativenumber = function(rel_nr) return string.format("%4d", rel_nr) end,
			},

			-- terminal: Create and toggle floating/split terminals.
			terminal = {
				enabled = true, -- Enable/disable terminal management
				-- Default terminal type: "float", "split", "vsplit", "tab"
				default_type = "float",
				-- Options for floating terminals
				float_opts = {
					border = "rounded",
					width = 0.9,
					height = 0.9,
					row = nil,
					col = nil,
					-- Additional float window options
					win_options = {},
				},
				-- Options for split terminals
				split_opts = {
					position = "bottom", -- "top", "bottom", "left", "right"
					size = 10, -- Height for horizontal splits, width for vertical splits
				},
				-- Shell to use for the terminal
				shell = vim.o.shell,
				-- Arguments for the shell
				shell_args = {},
				-- Working directory for the terminal (nil for current buffer's cwd)
				cwd = nil,
				-- Whether to enter terminal mode automatically
				enter_term_mode = true,
				-- Keymaps for terminal mode (e.g., to exit terminal mode)
				term_mode_keys = {
					-- "<C-\\><C-n>" is the default for exiting terminal mode
				},
			},

			-- toggle: Toggle keymaps integrated with which-key icons / colors.
			toggle = {
				enabled = true, -- Enable/disable toggle utility
				-- No specific configuration options commonly exposed beyond enabling/disabling
				-- This is a utility for creating toggle functions, e.g., for `dim`, `zen`, etc.
			},

			-- util: Utility functions for Snacks (library).
			util = {
				enabled = true, -- Enable/disable general utilities
				-- No specific configuration options commonly exposed beyond enabling/disabling
				-- This contains helper functions used internally by other snacks and can be used by users.
			},

			-- win: Create and manage floating windows or splits.
			win = {
				enabled = true, -- Enable/disable window management utilities
				-- No specific configuration options commonly exposed beyond enabling/disabling
				-- This provides functions for creating and manipulating windows programmatically.
			},

			-- words: Auto-show LSP references and quickly navigate between them.
			words = {
				enabled = true, -- Enable/disable word/reference navigation
				-- Automatically show references when cursor rests on a word
				auto_show_references = true,
				-- Delay before showing references (in milliseconds)
				delay = 500,
				-- Highlight group for word references
				hl = "SnacksWordReference",
				-- Whether to dim the background for references
				dim_background = true,
				-- Excluded filetypes
				excluded_filetypes = { "TelescopePrompt", "lazy", "packer", "NvimTree" },
			},

			-- zen: Zen mode • distraction-free coding.
			zen = {
				enabled = true, -- Enable/disable Zen mode
				-- Options for the Zen mode window
				win_options = {
					-- e.g., `number = false`, `relativenumber = false`, `list = false`, `cursorline = false`
				},
				-- Automatically resize to fill the screen
				auto_resize = true,
				-- Preserve current window layout when entering Zen mode
				preserve_layout = true,
				-- Center the content in Zen mode
				center = true,
				-- Hide statusline in Zen mode
				hide_statusline = true,
				-- Hide tabline in Zen mode
				hide_tabline = true,
				-- Hide number column in Zen mode
				hide_number = true,
				-- Hide sign column in Zen mode
				hide_signcolumn = true,
				-- Blacklist filetypes from entering Zen mode
				excluded_filetypes = { "NvimTree", "lazy", "packer", "dashboard" },
				-- Whether to enable "zoom" mode (maximize current window)
				zoom = {
					enabled = true,
					-- Keymap for zoom mode toggle
					-- zoom_key = "<leader>wm", -- Example keymap
				},
			},

			-- You can add any other custom snack-specific configurations here
			-- that might be documented in their individual `snacks.nvim` files.
		},
	},
}
