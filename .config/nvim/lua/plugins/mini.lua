return {
	{
		"echasnovski/mini.icons",
		version = "*",
		config = function()
			require("mini.icons").setup({
				-- Icon style: 'glyph' or 'ascii'
				style = "glyph",

				-- Default icon (when no specific icon is found)
				default = {},

				-- Directory icons
				directory = {
					-- Default directory icon
					default = { glyph = "󰉋", hl = "MiniIconsBlue" },

					-- Custom directory icons by name
					[".git"] = { glyph = "", hl = "MiniIconsRed" },
					[".github"] = { glyph = "", hl = "MiniIconsGrey" },
					[".vscode"] = { glyph = "", hl = "MiniIconsBlue" },
					["node_modules"] = { glyph = "", hl = "MiniIconsGreen" },
					["src"] = { glyph = "󰉋", hl = "MiniIconsBlue" },
					["lib"] = { glyph = "󰉋", hl = "MiniIconsBlue" },
					["bin"] = { glyph = "󰉋", hl = "MiniIconsYellow" },
					["docs"] = { glyph = "󰈙", hl = "MiniIconsGreen" },
					["test"] = { glyph = "󰙨", hl = "MiniIconsYellow" },
					["tests"] = { glyph = "󰙨", hl = "MiniIconsYellow" },
					["config"] = { glyph = "", hl = "MiniIconsGrey" },
					["dist"] = { glyph = "󰉋", hl = "MiniIconsOrange" },
					["build"] = { glyph = "󰉋", hl = "MiniIconsOrange" },
					["assets"] = { glyph = "󰉋", hl = "MiniIconsPurple" },
					["images"] = { glyph = "󰉏", hl = "MiniIconsPurple" },
					["public"] = { glyph = "󰉋", hl = "MiniIconsGreen" },
					["private"] = { glyph = "󰉋", hl = "MiniIconsRed" },
				},

				-- Extension-based file icons
				extension = {
					-- Programming languages
					lua = { glyph = "", hl = "MiniIconsBlue" },
					py = { glyph = "", hl = "MiniIconsYellow" },
					js = { glyph = "", hl = "MiniIconsYellow" },
					ts = { glyph = "", hl = "MiniIconsBlue" },
					jsx = { glyph = "", hl = "MiniIconsCyan" },
					tsx = { glyph = "", hl = "MiniIconsCyan" },
					rs = { glyph = "", hl = "MiniIconsOrange" },
					go = { glyph = "", hl = "MiniIconsCyan" },
					rb = { glyph = "", hl = "MiniIconsRed" },
					php = { glyph = "", hl = "MiniIconsPurple" },
					java = { glyph = "", hl = "MiniIconsOrange" },
					c = { glyph = "", hl = "MiniIconsBlue" },
					cpp = { glyph = "", hl = "MiniIconsBlue" },
					h = { glyph = "", hl = "MiniIconsPurple" },
					hpp = { glyph = "", hl = "MiniIconsPurple" },
					cs = { glyph = "󰌛", hl = "MiniIconsPurple" },
					swift = { glyph = "", hl = "MiniIconsOrange" },
					kt = { glyph = "", hl = "MiniIconsPurple" },
					dart = { glyph = "", hl = "MiniIconsBlue" },

					-- Web technologies
					html = { glyph = "", hl = "MiniIconsOrange" },
					css = { glyph = "", hl = "MiniIconsBlue" },
					scss = { glyph = "", hl = "MiniIconsPink" },
					sass = { glyph = "", hl = "MiniIconsPink" },
					less = { glyph = "", hl = "MiniIconsBlue" },
					vue = { glyph = "󰡄", hl = "MiniIconsGreen" },
					svelte = { glyph = "", hl = "MiniIconsOrange" },
					angular = { glyph = "", hl = "MiniIconsRed" },

					-- Data and config files
					json = { glyph = "", hl = "MiniIconsYellow" },
					yaml = { glyph = "", hl = "MiniIconsGrey" },
					yml = { glyph = "", hl = "MiniIconsGrey" },
					toml = { glyph = "", hl = "MiniIconsGrey" },
					xml = { glyph = "󰗀", hl = "MiniIconsOrange" },
					csv = { glyph = "󰈙", hl = "MiniIconsGreen" },

					-- Documentation
					md = { glyph = "", hl = "MiniIconsBlue" },
					mdx = { glyph = "", hl = "MiniIconsBlue" },
					txt = { glyph = "󰈙", hl = "MiniIconsGrey" },
					tex = { glyph = "", hl = "MiniIconsGreen" },
					pdf = { glyph = "", hl = "MiniIconsRed" },

					-- Shell and scripts
					sh = { glyph = "", hl = "MiniIconsGreen" },
					bash = { glyph = "", hl = "MiniIconsGreen" },
					zsh = { glyph = "", hl = "MiniIconsGreen" },
					fish = { glyph = "", hl = "MiniIconsGreen" },
					ps1 = { glyph = "󰨊", hl = "MiniIconsBlue" },

					-- Images
					png = { glyph = "󰉏", hl = "MiniIconsPurple" },
					jpg = { glyph = "󰉏", hl = "MiniIconsPurple" },
					jpeg = { glyph = "󰉏", hl = "MiniIconsPurple" },
					gif = { glyph = "󰉏", hl = "MiniIconsPurple" },
					svg = { glyph = "󰜡", hl = "MiniIconsYellow" },
					ico = { glyph = "󰉏", hl = "MiniIconsPurple" },
					webp = { glyph = "󰉏", hl = "MiniIconsPurple" },

					-- Archives
					zip = { glyph = "", hl = "MiniIconsYellow" },
					tar = { glyph = "", hl = "MiniIconsYellow" },
					gz = { glyph = "", hl = "MiniIconsYellow" },
					["7z"] = { glyph = "", hl = "MiniIconsYellow" },
					rar = { glyph = "", hl = "MiniIconsYellow" },

					-- Executables
					exe = { glyph = "", hl = "MiniIconsRed" },
					app = { glyph = "", hl = "MiniIconsRed" },
					deb = { glyph = "", hl = "MiniIconsRed" },
					rpm = { glyph = "", hl = "MiniIconsRed" },

					-- Database
					sql = { glyph = "", hl = "MiniIconsBlue" },
					db = { glyph = "", hl = "MiniIconsBlue" },
					sqlite = { glyph = "", hl = "MiniIconsBlue" },

					-- Environment and config
					env = { glyph = "", hl = "MiniIconsYellow" },
					ini = { glyph = "", hl = "MiniIconsGrey" },
					conf = { glyph = "", hl = "MiniIconsGrey" },
					log = { glyph = "󰌱", hl = "MiniIconsGrey" },

					-- Version control
					gitignore = { glyph = "", hl = "MiniIconsRed" },
					gitattributes = { glyph = "", hl = "MiniIconsRed" },

					-- Package managers
					lock = { glyph = "", hl = "MiniIconsRed" },
				},

				-- Filename-based icons (takes priority over extension)
				file = {
					-- Config files
					[".gitignore"] = { glyph = "", hl = "MiniIconsRed" },
					[".gitattributes"] = { glyph = "", hl = "MiniIconsRed" },
					[".gitmodules"] = { glyph = "", hl = "MiniIconsRed" },
					["package.json"] = { glyph = "", hl = "MiniIconsGreen" },
					["package-lock.json"] = { glyph = "", hl = "MiniIconsRed" },
					["yarn.lock"] = { glyph = "", hl = "MiniIconsBlue" },
					["Cargo.toml"] = { glyph = "", hl = "MiniIconsOrange" },
					["Cargo.lock"] = { glyph = "", hl = "MiniIconsRed" },
					["requirements.txt"] = { glyph = "", hl = "MiniIconsYellow" },
					["Pipfile"] = { glyph = "", hl = "MiniIconsYellow" },
					["pyproject.toml"] = { glyph = "", hl = "MiniIconsYellow" },
					["Gemfile"] = { glyph = "", hl = "MiniIconsRed" },
					["Gemfile.lock"] = { glyph = "", hl = "MiniIconsRed" },
					["go.mod"] = { glyph = "", hl = "MiniIconsCyan" },
					["go.sum"] = { glyph = "", hl = "MiniIconsCyan" },
					["composer.json"] = { glyph = "", hl = "MiniIconsPurple" },
					["composer.lock"] = { glyph = "", hl = "MiniIconsPurple" },

					-- Build and CI files
					["Makefile"] = { glyph = "", hl = "MiniIconsGrey" },
					["makefile"] = { glyph = "", hl = "MiniIconsGrey" },
					["Dockerfile"] = { glyph = "󰡨", hl = "MiniIconsBlue" },
					["docker-compose.yml"] = { glyph = "󰡨", hl = "MiniIconsBlue" },
					["docker-compose.yaml"] = { glyph = "󰡨", hl = "MiniIconsBlue" },
					[".dockerignore"] = { glyph = "󰡨", hl = "MiniIconsGrey" },
					["Vagrantfile"] = { glyph = "", hl = "MiniIconsBlue" },

					-- Documentation
					["README.md"] = { glyph = "", hl = "MiniIconsBlue" },
					["README"] = { glyph = "", hl = "MiniIconsBlue" },
					["LICENSE"] = { glyph = "󰿃", hl = "MiniIconsYellow" },
					["CHANGELOG.md"] = { glyph = "", hl = "MiniIconsGreen" },
					["CONTRIBUTING.md"] = { glyph = "", hl = "MiniIconsPurple" },

					-- Neovim specific
					["init.lua"] = { glyph = "", hl = "MiniIconsBlue" },
					["init.vim"] = { glyph = "", hl = "MiniIconsGreen" },
					[".vimrc"] = { glyph = "", hl = "MiniIconsGreen" },
					[".nvimrc"] = { glyph = "", hl = "MiniIconsBlue" },

					-- Editor configs
					[".editorconfig"] = { glyph = "", hl = "MiniIconsGrey" },
					[".prettierrc"] = { glyph = "", hl = "MiniIconsPink" },
					[".eslintrc.js"] = { glyph = "", hl = "MiniIconsPurple" },
					[".eslintrc.json"] = { glyph = "", hl = "MiniIconsPurple" },
					["tsconfig.json"] = { glyph = "", hl = "MiniIconsBlue" },
					["jsconfig.json"] = { glyph = "", hl = "MiniIconsYellow" },
					["webpack.config.js"] = { glyph = "󰜪", hl = "MiniIconsBlue" },
					["vite.config.js"] = { glyph = "", hl = "MiniIconsYellow" },
					["rollup.config.js"] = { glyph = "", hl = "MiniIconsRed" },
				},

				-- Filetype-based icons (fallback when extension and filename don't match)
				filetype = {
					help = { glyph = "󰈙", hl = "MiniIconsPurple" },
					man = { glyph = "", hl = "MiniIconsGrey" },
					qf = { glyph = "󰁨", hl = "MiniIconsRed" },
					checkhealth = { glyph = "󰓙", hl = "MiniIconsGreen" },
					terminal = { glyph = "", hl = "MiniIconsGreen" },
					packer = { glyph = "", hl = "MiniIconsBlue" },
					lazy = { glyph = "󰒲", hl = "MiniIconsBlue" },
					mason = { glyph = "", hl = "MiniIconsOrange" },
					NvimTree = { glyph = "󰉋", hl = "MiniIconsGreen" },
					["neo-tree"] = { glyph = "󰉋", hl = "MiniIconsGreen" },
					Trouble = { glyph = "󰙅", hl = "MiniIconsRed" },
					TelescopePrompt = { glyph = "", hl = "MiniIconsBlue" },
					dashboard = { glyph = "", hl = "MiniIconsBlue" },
					alpha = { glyph = "", hl = "MiniIconsBlue" },
					startify = { glyph = "", hl = "MiniIconsBlue" },
				},

				-- LSP kind icons (for completion, symbols, etc.)
				lsp = {
					array = { glyph = "󰅪", hl = "MiniIconsOrange" },
					boolean = { glyph = "◩", hl = "MiniIconsOrange" },
					class = { glyph = "󰌗", hl = "MiniIconsBlue" },
					color = { glyph = "󰏘", hl = "MiniIconsRed" },
					constant = { glyph = "󰏿", hl = "MiniIconsOrange" },
					constructor = { glyph = "", hl = "MiniIconsBlue" },
					enum = { glyph = "", hl = "MiniIconsBlue" },
					enummember = { glyph = "", hl = "MiniIconsBlue" },
					event = { glyph = "", hl = "MiniIconsBlue" },
					field = { glyph = "󰜢", hl = "MiniIconsBlue" },
					file = { glyph = "󰈙", hl = "MiniIconsBlue" },
					folder = { glyph = "󰉋", hl = "MiniIconsBlue" },
					["function"] = { glyph = "󰊕", hl = "MiniIconsBlue" },
					interface = { glyph = "", hl = "MiniIconsBlue" },
					key = { glyph = "󰌋", hl = "MiniIconsBlue" },
					keyword = { glyph = "󰌋", hl = "MiniIconsBlue" },
					method = { glyph = "󰆧", hl = "MiniIconsBlue" },
					module = { glyph = "", hl = "MiniIconsBlue" },
					namespace = { glyph = "󰌗", hl = "MiniIconsBlue" },
					null = { glyph = "󰟢", hl = "MiniIconsBlue" },
					number = { glyph = "", hl = "MiniIconsOrange" },
					object = { glyph = "󰅩", hl = "MiniIconsBlue" },
					operator = { glyph = "󰆕", hl = "MiniIconsBlue" },
					package = { glyph = "", hl = "MiniIconsBlue" },
					property = { glyph = "󰜢", hl = "MiniIconsBlue" },
					reference = { glyph = "󰈇", hl = "MiniIconsBlue" },
					snippet = { glyph = "", hl = "MiniIconsBlue" },
					string = { glyph = "󰉿", hl = "MiniIconsGreen" },
					struct = { glyph = "󰌗", hl = "MiniIconsBlue" },
					text = { glyph = "󰉿", hl = "MiniIconsBlue" },
					typeparameter = { glyph = "", hl = "MiniIconsBlue" },
					unit = { glyph = "󰑭", hl = "MiniIconsBlue" },
					value = { glyph = "󰎠", hl = "MiniIconsBlue" },
					variable = { glyph = "󰀫", hl = "MiniIconsBlue" },
				},

				-- Operating system icons
				os = {
					arch = { glyph = "", hl = "MiniIconsBlue" },
					centos = { glyph = "", hl = "MiniIconsPurple" },
					debian = { glyph = "", hl = "MiniIconsRed" },
					fedora = { glyph = "", hl = "MiniIconsBlue" },
					linux = { glyph = "", hl = "MiniIconsYellow" },
					macos = { glyph = "", hl = "MiniIconsGrey" },
					redhat = { glyph = "", hl = "MiniIconsRed" },
					ubuntu = { glyph = "", hl = "MiniIconsOrange" },
					windows = { glyph = "", hl = "MiniIconsBlue" },
				},
			})

			-- Setup custom highlight groups with better colors
			local function setup_highlights()
				-- Define custom highlight groups
				vim.api.nvim_set_hl(0, "MiniIconsBlue", { fg = "#61afef" })
				vim.api.nvim_set_hl(0, "MiniIconsGreen", { fg = "#98c379" })
				vim.api.nvim_set_hl(0, "MiniIconsYellow", { fg = "#e5c07b" })
				vim.api.nvim_set_hl(0, "MiniIconsOrange", { fg = "#d19a66" })
				vim.api.nvim_set_hl(0, "MiniIconsRed", { fg = "#e06c75" })
				vim.api.nvim_set_hl(0, "MiniIconsPurple", { fg = "#c678dd" })
				vim.api.nvim_set_hl(0, "MiniIconsPink", { fg = "#e06c75" })
				vim.api.nvim_set_hl(0, "MiniIconsCyan", { fg = "#56b6c2" })
				vim.api.nvim_set_hl(0, "MiniIconsGrey", { fg = "#5c6370" })
			end

			setup_highlights()

			-- Auto-reload highlights on colorscheme change
			vim.api.nvim_create_autocmd("ColorScheme", {
				pattern = "*",
				callback = setup_highlights,
				desc = "Reload mini.icons highlights on colorscheme change",
			})

			-- Optional: Create commands for icon utilities
			vim.api.nvim_create_user_command("MiniIconsTest", function()
				-- Test icons for current buffer
				local icon, hl = require("mini.icons").get("file", vim.fn.expand("%:t"))
				print(string.format("File: %s | Icon: %s | Highlight: %s", vim.fn.expand("%:t"), icon, hl))
			end, { desc = "Test mini.icons for current file" })

			vim.api.nvim_create_user_command("MiniIconsList", function()
				-- Show available categories
				print("Mini.icons categories: file, extension, filetype, directory, lsp, os")
			end, { desc = "List mini.icons categories" })
		end,
	},
}
