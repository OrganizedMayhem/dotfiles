return {
	"obsidian-nvim/obsidian.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"folke/snacks.nvim", -- snacks picker
		"Saghen/blink.cmp", -- if you haven't: "githubuser/blink.cmp"
	},
	lazy = false, -- load on startup so commands are always available
	config = function()
		require("obsidian").setup({
			legacy_commands = false, -- use new standardized commands
			workspaces = {
				{ name = "Personal", path = "~/vaults/Personal" },
				{ name = "Work", path = "~/vaults/Work" },
			},

			daily_notes = {
				folder = "Summaries/Dailies/intake",
				date_format = "%Y-%m-%d",
				alias_format = "%B %-d, %Y",
				template = "daily.md",
				default_tags = { "daily-notes" }, -- new option
				workdays_only = false, -- new option
			},

			completion = {
				nvim_cmp = false, -- disable nvim-cmp completion
				blink = true, -- enable blink completion
				min_chars = 2,
				create_new = true,
			},

			note_path_func = function(spec)
				local path = spec.dir / tostring(spec.id)
				return path:with_suffix(".md")
			end,

			wiki_link_func = function(opts)
				return require("obsidian.util").wiki_link_id_prefix(opts)
			end,

			markdown_link_func = function(opts)
				return require("obsidian.util").markdown_link(opts)
			end,

			preferred_link_style = "wiki",

			image_name_func = function()
				return string.format("%s-", os.time())
			end,

			templates = {
				folder = "templates",
				date_format = "%Y-%m-%d",
				time_format = "%H:%M:%S",
				substitutions = {},
			},

			follow_url_func = function(url)
				vim.fn.jobstart({ "open", url }) -- Mac
				-- vim.fn.jobstart({ "xdg-open", url }) -- Linux
			end,

			open = {
				use_advanced_uri = false,
				func = vim.ui.open,
			},

			picker = {
				name = "snacks.pick", -- using snacks.nvim picker
				mappings = {
					new = "<C-x>",
					insert_link = "<C-l>",
				},
				tag_mappings = {
					tag_note = "<C-x>",
					insert_tag = "<C-l>",
				},
				note_mappings = {
					new = "<C-x>",
					insert_link = "<C-l>",
				},
			},

			open_notes_in = "current",
			frontmatter = {
				enabled = true,
			},
			search = {
				sort_reversed = true,
				search_max_lines = 1000,
				sort_by = "modified",
			},

			callbacks = {
				post_setup = function(client) end,
				enter_note = function(client, note) end,
				leave_note = function(client, note) end,
				pre_write_note = function(client, note) end,
				post_set_workspace = function(client, workspace) end,
			},

			ui = {
				enable = true,
				update_debounce = 200,
				max_file_length = 5000,
				bullets = { char = "•", hl_group = "ObsidianBullet" },
				external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
				reference_text = { hl_group = "ObsidianRefText" },
				highlight_text = { hl_group = "ObsidianHighlightText" },
				tags = { hl_group = "ObsidianTag" },
				block_ids = { hl_group = "ObsidianBlockID" },
				hl_groups = {
					ObsidianTodo = { bold = true, fg = "#f78c6c" },
					ObsidianDone = { bold = true, fg = "#89ddff" },
					ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
					ObsidianTilde = { bold = true, fg = "#ff5370" },
					ObsidianImportant = { bold = true, fg = "#d73128" },
					ObsidianBullet = { bold = true, fg = "#89ddff" },
					ObsidianRefText = { underline = true, fg = "#c792ea" },
					ObsidianExtLinkIcon = { fg = "#c792ea" },
					ObsidianTag = { italic = true, fg = "#89ddff" },
					ObsidianBlockID = { italic = true, fg = "#89ddff" },
					ObsidianHighlightText = { bg = "#75662e" },
				},
			},

			attachments = {
				img_folder = "assets/imgs",
				img_text_func = function(client, path)
					path = client:vault_relative_path(path) or path
					return string.format("![%s](%s)", path.name, path)
				end,
			},
		})
	end,
}
