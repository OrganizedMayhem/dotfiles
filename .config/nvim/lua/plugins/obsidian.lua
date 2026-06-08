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
				{ name = "Work", path = "~/vaults/Travel" },
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
				min_chars = 2,
				create_new = true,
			},
			link = {
				style = "wiki",
				format = "shortest",
			},
			note_path_func = function(spec)
				local path = spec.dir / tostring(spec.id)
				return path:with_suffix(".md")
			end,

			image_name_func = function()
				return string.format("%s-", os.time())
			end,

			templates = {
				folder = "templates",
				date_format = "%Y-%m-%d",
				time_format = "%H:%M:%S",
				substitutions = {},
			},

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
				img_text_func = function(client, path)
					path = client:vault_relative_path(path) or path
					return string.format("![%s](%s)", path.name, path)
				end,
			},
		})

		local function prompt_chain(questions, results, idx, on_done)
			if idx > #questions then
				on_done(results)
				return
			end
			local q = questions[idx]
			local next_step = function(value)
				if value == nil or value == "" then
					vim.notify("Options trade: cancelled", vim.log.levels.INFO)
					return
				end
				results[q.key] = value
				prompt_chain(questions, results, idx + 1, on_done)
			end
			if q.type == "select" then
				vim.ui.select(q.choices, { prompt = q.prompt }, next_step)
			else
				vim.ui.input({ prompt = q.prompt, default = q.default }, next_step)
			end
		end

		vim.api.nvim_create_user_command("ObsidianOptionsTrade", function()
			local vault = vim.fn.expand("~/vaults/Personal")
			local template_path = vault .. "/templates/options-trade.md"
			local today = os.date("%Y-%m-%d")
			local year = os.date("%Y")

			local questions = {
				{ key = "TICKER", prompt = "Ticker: ", type = "input" },
				{ key = "STRATEGY", prompt = "Strategy", type = "select", choices = { "Call", "Put" } },
				{ key = "BIAS", prompt = "Directional bias", type = "select",
					choices = { "Bullish", "Bearish", "Neutral" } },
				{ key = "TIMEFRAME", prompt = "Timeframe", type = "select",
					choices = { "Intraday", "Swing", "Longer-term" } },
				{ key = "STRIKE", prompt = "Strike(s): ", type = "input" },
				{ key = "EXPIRATION", prompt = "Expiration (YYYY-MM-DD): ", type = "input" },
				{ key = "PREMIUM", prompt = "Premium per contract ($): ", type = "input" },
				{ key = "CONTRACTS", prompt = "Contracts: ", type = "input" },
				{ key = "UNDERLYING", prompt = "Underlying price at entry: ", type = "input" },
			}

			prompt_chain(questions, {}, 1, function(answers)
				answers.DATE = today
				answers.TICKER = answers.TICKER:upper()

				local premium = tonumber(answers.PREMIUM)
				local contracts = tonumber(answers.CONTRACTS)
				if premium and contracts then
					answers.TOTAL_COST = string.format("%.2f", premium * contracts * 100)
				else
					answers.TOTAL_COST = ""
				end

				local exp_ok, exp_time = pcall(function()
					local y, m, d = answers.EXPIRATION:match("(%d+)-(%d+)-(%d+)")
					return os.time({ year = tonumber(y), month = tonumber(m), day = tonumber(d) })
				end)
				if exp_ok and exp_time then
					answers.DTE = tostring(math.floor((exp_time - os.time()) / 86400))
				else
					answers.DTE = ""
				end

				local f = io.open(template_path, "r")
				if not f then
					vim.notify("Cannot read template: " .. template_path, vim.log.levels.ERROR)
					return
				end
				local content = f:read("*a")
				f:close()

				content = content:gsub("<<([%w_]+)>>", function(key)
					return answers[key] or ("<<" .. key .. ">>")
				end)

				local dir = string.format("%s/Trading/%s", vault, year)
				vim.fn.mkdir(dir, "p")
				local out_path = string.format("%s/%s-%s.md", dir, answers.TICKER, today)

				if vim.fn.filereadable(out_path) == 1 then
					vim.notify("Note already exists: " .. out_path, vim.log.levels.WARN)
					vim.cmd("edit " .. vim.fn.fnameescape(out_path))
					return
				end

				local out = io.open(out_path, "w")
				if not out then
					vim.notify("Cannot write: " .. out_path, vim.log.levels.ERROR)
					return
				end
				out:write(content)
				out:close()

				vim.cmd("edit " .. vim.fn.fnameescape(out_path))
			end)
		end, { desc = "Create a new options-trade note via prompts" })
	end,
}
