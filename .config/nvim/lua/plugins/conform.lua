return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" }, -- Lazy load on BufWritePre for format-on-save
	cmd = { "ConformInfo" }, -- Also loads when :ConformInfo is called
	init = function()
		-- Set `formatexpr` to allow 'gq' and other built-in formatting commands to use Conform
		vim.o.formatexpr = [[v:lua.require("conform").formatexpr()]]
	end,
	opts = {
		-- Global options for conform.nvim

		-- default_format_opts: Table of default options passed to `conform.format()`.
		-- These apply to all formatting calls unless overridden.
		default_format_opts = {
			-- lsp_format: How to handle LSP formatting when a conform formatter is also available.
			-- "fallback": Use LSP formatting if no conform formatter is found for the filetype. (Recommended)
			-- "never": Never use LSP formatting.
			-- "always": Always try LSP formatting first, then conform.
			lsp_format = "fallback",
			-- timeout_ms: Time in milliseconds to block for synchronous formatting.
			-- No effect if `async = true`.
			timeout_ms = 1000,
			-- async: If true, the method won't block.
			-- If the buffer is modified before the formatter completes, formatting is discarded.
			-- Defaults to `false` for `format_on_save` and `default_format_opts` (meaning sync by default).
			-- You might set this to `true` for manual formatting commands if you want them non-blocking.
			async = true,
			-- This makes formatting an undoable "step" with your previous edit.
			-- Recommended to keep this `true` for a good undo history.
			undojoin = true,
			-- bufnr: The buffer to format. Defaults to the current buffer (0).
			-- bufnr = 0,
			-- formatters: List of formatters to run. Defaults to all formatters for the buffer filetype.
			-- This allows you to specify a subset of formatters or a specific order.
			formatters = { "stylua", "ruff" },
			-- range: Table with `start` and `end` (line numbers) for range formatting.
			-- { start = { line, col }, ['end'] = { line, col } }
			-- Conform automatically provides range formatting even if the underlying formatter doesn't support it.
			-- range = nil,
			-- id: Passed to `vim.lsp.buf.format()` when using LSP formatting.
			-- name: Passed to `vim.lsp.buf.format()` when using LSP formatting.
			-- filter: A function `fun(client: table): boolean` passed to `vim.lsp.buf.format()` when using LSP formatting.
		},
		format_on_save = {
			-- I recommend these options for format-on-save:
			lsp_format = "fallback",
			timeout_ms = 1000, -- Give formatters enough time
			async = false, -- Typically want sync formatting on save for immediate feedback
			undojoin = true, -- Merge formatting changes with the save operation in undo history
		},

		-- log_level: Controls the verbosity of Conform's logging.
		-- Possible values: `vim.log.levels.ERROR`, `vim.log.levels.WARN`, `vim.log.levels.INFO`, `vim.log.levels.DEBUG`, `vim.log.levels.TRACE`
		log_level = vim.log.levels.ERROR,

		-- notify_on_error: Conform will notify you when a formatter errors.
		notify_on_error = true,

		-- notify_no_formatters: Conform will notify you when no formatters are available for the buffer.
		notify_no_formatters = true,

		-- formatters_by_ft: Map of filetype to a list of formatter names to run.
		-- Conform will try each formatter in the list until one succeeds.
		-- You can also use `stop_after_first = true` within the list to stop after the first successful formatter.
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "ruff", "isort" }, -- isort first, then black
			json = { "prettierd", "format_on_savettier", stop_after_first = true },
			yaml = { "prettierd", "prettier", stop_after_first = true },
			markdown = { "prettierd", "prettier", stop_after_first = true },
			sh = { "shfmt" },
			go = { "gofumpt" }, -- goimports first, then gofmt
			rust = { "rustfmt" },
		},

		-- formatters: Define or override specific formatter configurations.
		-- This is where you can pass arguments to formatters, set custom commands, etc.
	},
}
