-- Lazy.nvim configuration for mini.statusline
-- Add this to your lazy.nvim plugin specification

return {
	{
		"echasnovski/mini.statusline",
		version = "*", -- Use stable version
		event = "VeryLazy", -- Load after startup for better performance
		dependencies = {
			-- Optional dependencies for enhanced functionality
			"echasnovski/mini.icons", -- For file type icons
			--"echasnovski/mini.git", -- For git information
			"echasnovski/mini.diff", -- For diff information
			-- Alternative fallbacks if you don't use mini.nvim ecosystem:
			-- 'nvim-tree/nvim-web-devicons', -- Alternative to mini.icons
			-- 'lewis6991/gitsigns.nvim',     -- Alternative to mini.git/diff
		},
		config = function()
			-- Helper functions for custom statusline sections
			local M = {}

			-- Custom DAP section
			function M.dap_status()
				local dap_ok, dap = pcall(require, "dap")
				if not dap_ok then
					return ""
				end

				local session = dap.session()
				if session then
					local status = session.capabilities and session.capabilities.supportsStepBack and "󰴯" or "󱍮"
					return "%#DiagnosticError#" .. status .. " DAP"
				end
				return ""
			end

			-- Custom macro recording indicator
			function M.macro_status()
				local recording_register = vim.fn.reg_recording()
				if recording_register ~= "" then
					return "%#DiagnosticWarn# REC @" .. recording_register
				end
				return ""
			end

			-- Custom treesitter status
			function M.treesitter_status()
				if not vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()] then
					return ""
				end
				return "%#DiagnosticInfo# TS"
			end

			-- Custom spell checker status
			function M.spell_status()
				if vim.wo.spell then
					return "%#DiagnosticHint# SPELL"
				end
				return ""
			end

			-- Custom file encoding/format (only show if not UTF-8/unix)
			function M.encoding_info()
				local encoding = vim.bo.fileencoding or vim.o.encoding
				local format = vim.bo.fileformat
				if encoding ~= "utf-8" or format ~= "unix" then
					return string.format(" [%s:%s]", encoding:upper(), format:upper())
				end
				return ""
			end

			-- Custom indentation info
			function M.indent_info()
				local icon = vim.bo.expandtab and "󱁐" or "󰌒"
				local size = vim.bo.expandtab and vim.bo.shiftwidth or vim.bo.tabstop
				return string.format(" %s%d", icon, size)
			end

			-- Custom LSP progress (more detailed than default)

			require("mini.statusline").setup({
				content = {
					active = function()
						local mode, mode_hl = require("mini.statusline").section_mode({ trunc_width = 120 })
						local git = require("mini.statusline").section_git({ trunc_width = 75 })
						local diff = require("mini.statusline").section_diff({ trunc_width = 75 })
						local diagnostics = require("mini.statusline").section_diagnostics({
							trunc_width = 75,
							-- Custom signs with colors for each diagnostic level
							signs = {
								ERROR = "%#DiagnosticError#󰅚",
								WARN = "%#DiagnosticWarn#󰀪",
								INFO = "%#DiagnosticInfo#󰋽",
								HINT = "%#DiagnosticHint#󰌶",
							},
						})
						local lsp = require("mini.statusline").section_lsp({ trunc_width = 75 })
						local filename = require("mini.statusline").section_filename({ trunc_width = 140 })
						local fileinfo = require("mini.statusline").section_fileinfo({ trunc_width = 120 })
						local location = require("mini.statusline").section_location({ trunc_width = 75 })
						local search = require("mini.statusline").section_searchcount({ trunc_width = 75 })

						-- Get custom sections
						local dap_status = M.dap_status()
						local macro_status = M.macro_status()
						local ts_status = M.treesitter_status()
						local spell_status = M.spell_status()
						local encoding_info = M.encoding_info()
						local indent_info = M.indent_info()

						return require("mini.statusline").combine_groups({
							{ hl = mode_hl, strings = { mode } },
							{
								hl = "MiniStatuslineDevinfo",
								strings = {
									git,
									diff,
									diagnostics,
									lsp,
									lsp_progress,
									dap_status,
									macro_status,
									ts_status,
									spell_status,
								},
							},
							"%<", -- Mark general truncate point
							{ hl = "MiniStatuslineFilename", strings = { filename } },
							"%=", -- End left alignment
							{ hl = "MiniStatuslineFileinfo", strings = { fileinfo, encoding_info, indent_info } },
							{ hl = mode_hl, strings = { search, location } },
						})
					end,

					inactive = function()
						-- Simpler statusline for inactive windows
						local filename = require("mini.statusline").section_filename({ trunc_width = 140 })
						return require("mini.statusline").combine_groups({
							{ hl = "MiniStatuslineInactive", strings = { " ", filename } },
							"%=",
							{
								hl = "MiniStatuslineInactive",
								strings = { require("mini.statusline").section_location({ trunc_width = 75 }) },
							},
						})
					end,
				},

				-- Use icons (requires Nerd Font)
				use_icons = true,
			})

			-- Custom highlight groups for better visual separation
			vim.api.nvim_set_hl(0, "MiniStatuslineDevinfo", {
				fg = "#7c3aed", -- Purple for dev info
				bg = "NONE",
			})
			vim.api.nvim_set_hl(0, "MiniStatuslineFilename", {
				fg = "#059669", -- Green for filename
				bg = "NONE",
				bold = true,
			})
			vim.api.nvim_set_hl(0, "MiniStatuslineFileinfo", {
				fg = "#0891b2", -- Cyan for file info
				bg = "NONE",
			})
			vim.api.nvim_set_hl(0, "MiniStatuslineInactive", {
				link = "StatusLineNC",
			})

			-- Autocommands to refresh statusline when various states change
			local augroup = vim.api.nvim_create_augroup("MiniStatuslineRefresh", { clear = true })

			-- Refresh on DAP events
			vim.api.nvim_create_autocmd({ "User" }, {
				group = augroup,
				pattern = { "DapSessionStarted", "DapSessionStopped" },
				callback = function()
					vim.cmd("redrawstatus")
				end,
			})

			-- Refresh on macro recording
			vim.api.nvim_create_autocmd({ "RecordingEnter", "RecordingLeave" }, {
				group = augroup,
				callback = function()
					vim.cmd("redrawstatus")
				end,
			})

			-- Refresh on spell toggle
			vim.api.nvim_create_autocmd({ "OptionSet" }, {
				group = augroup,
				pattern = "spell",
				callback = function()
					vim.cmd("redrawstatus")
				end,
			})

			-- Refresh on LSP attach/detach
			vim.api.nvim_create_autocmd({ "LspAttach", "LspDetach" }, {
				group = augroup,
				callback = function()
					vim.cmd("redrawstatus")
				end,
			})
		end,
	},

	-- Optional: If you want to use nvim-dap for debugging integration
	{
		"mfussenegger/nvim-dap",
		lazy = true, -- Only load when needed
		config = function()
			-- Your DAP configuration here
		end,
	},
}
