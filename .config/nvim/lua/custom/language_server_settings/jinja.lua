return {
	-- LSP Configuration
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/nvim-cmp",
		},
		config = function()
			local lspconfig = require("lspconfig")
			local configs = require("lspconfig.configs")

			-- Configure Jinja LSP if not already defined
			if not configs.jinja_lsp then
				configs.jinja_lsp = {
					default_config = {
						name = "jinja-lsp",
						cmd = { "jinja-lsp" },
						filetypes = { "jinja", "html", "j2" },
						root_dir = function(fname)
							return "."
						end,
						init_options = {
							templates = "./templates",
							backend = { "./src" },
							lang = "rust",
						},
					},
				}
			end

			-- Set up capabilities for autocompletion
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- Initialize the Jinja LSP
			lspconfig.jinja_lsp.setup({
				capabilities = capabilities,
			})
		end,
	},

	-- Autocompletion
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				mapping = {
					["<C-p>"] = cmp.mapping.select_prev_item(),
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-d>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.close(),
					["<CR>"] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Replace,
						select = true,
					}),
				},
				sources = {
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "buffer" },
					{ name = "path" },
				},
			})
		end,
	},
}
