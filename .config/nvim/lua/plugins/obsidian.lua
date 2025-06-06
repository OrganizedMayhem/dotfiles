return {
	"obsidian-nvim/obsidian.nvim",
	dependencies = { "nvim-lua/plenary.nvim", "ibhagwan/fzf-lua" },
	lazy = true,
	ft = "markdown",
	config = function()
		require("obsidian").setup({
			-- A list of workspace names, paths, and configuration overrides.
			workspaces = {
				{
					name = "notes",
					path = "~/vaults/Personal",
				},
				{
					name = "Work",
					path = "~/vaults/Work",
				},
			},
			log_level = vim.log.levels.INFO,
			daily_notes = {
				default = {},
				folder = "dailies/%Y-%m",
				date_format = "%Y-%m-%d",
				alias_format = "%B %-d, %Y",
				template = "daily.md",
			},

			completion = {
				nvim_cmp = false,
				min_chars = 2,
			},

			note_id_func = function(title)
				local suffix = ""
				if title ~= nil then
					suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
				else
					for _ = 1, 4 do
						suffix = suffix .. string.char(math.random(65, 90))
					end
				end
				return tostring(os.time()) .. "-" .. suffix
			end,

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

			disable_frontmatter = false,

			note_frontmatter_func = function(note)
				if note.title then
					note:add_alias(note.title)
				end

				local out = {
					id = note.id,
					aliases = note.aliases,
					tags = note.tags,
				}

				if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
					for k, v in pairs(note.metadata) do
						out[k] = v
					end
				end
				return out
			end,

			templates = {
				folder = "templates",
				date_format = "%Y-%m-%d",
				time_format = "%H:%M",
				substitutions = {},
			},

			follow_url_func = function(url)
				vim.fn.jobstart({ "open", url }) -- Mac OS
				-- vim.fn.jobstart({"xdg-open", url})  -- linux
			end,

			--			use_advanced_uri = true,

			picker = {
				name = "fzf-lua",
				mappings = {
					new = "<C-x>",
					insert_link = "<C-l>",
				},
				tag_mappings = name,
				note_mappings = use_advanced_uri,
			},

			sort_by = "modified",
			sort_reversed = true,

			search_max_lines = 1000,

			open_notes_in = "current",

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
				checkboxes = {
					[" "] = {
						char = "󰄱",
						hl_group = "ObsidianTodo",
					},
					["x"] = {
						char = "",
						hl_group = "ObsidianDone",
					},
					[">"] = {
						char = "",
						hl_group = "ObsidianRightArrow",
					},
					["~"] = {
						char = "󰰱",
						hl_group = "ObsidianTilde",
					},
					["!"] = {
						char = "",
						hl_group = "ObsidianImportant",
					},
				},
				bullets = {
					char = "•",
					hl_group = "ObsidianBullet",
				},
				external_link_icon = {
					char = "",
					hl_group = "ObsidianExtLinkIcon",
				},
				reference_text = {
					hl_group = "ObsidianRefText",
				},
				highlight_text = {
					hl_group = "ObsidianHighlightText",
				},
				tags = {
					hl_group = "ObsidianTag",
				},
				block_ids = {
					hl_group = "ObsidianBlockID",
				},
				hl_groups = {
					ObsidianTodo = {
						bold = true,
						fg = "#f78c6c",
					},
					ObsidianDone = {
						bold = true,
						fg = "#89ddff",
					},
					ObsidianRightArrow = {
						bold = true,
						fg = "#f78c6c",
					},
					ObsidianTilde = {
						bold = true,
						fg = "#ff5370",
					},
					ObsidianImportant = {
						bold = true,
						fg = "#d73128",
					},
					ObsidianBullet = {
						bold = true,
						fg = "#89ddff",
					},
					ObsidianRefText = {
						underline = true,
						fg = "#c792ea",
					},
					ObsidianExtLinkIcon = {
						fg = "#c792ea",
					},
					ObsidianTag = {
						italic = true,
						fg = "#89ddff",
					},
					ObsidianBlockID = {
						italic = true,
						fg = "#89ddff",
					},
					ObsidianHighlightText = {
						bg = "#75662e",
					},
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
