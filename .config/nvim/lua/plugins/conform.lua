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
			-- async = false,
			-- dry_run: If true, don't apply formatting changes to the buffer.
			-- Useful for testing formatter output without modifying the file.
			-- dry_run = false,
			-- undojoin: Use undojoin to merge formatting changes with previous edit.
			-- This makes formatting an undoable "step" with your previous edit.
			-- Recommended to keep this `true` for a good undo history.
			undojoin = true,
			-- bufnr: The buffer to format. Defaults to the current buffer (0).
			-- bufnr = 0,
			-- formatters: List of formatters to run. Defaults to all formatters for the buffer filetype.
			-- This allows you to specify a subset of formatters or a specific order.
			-- formatters = { "stylua", "black" },
			-- range: Table with `start` and `end` (line numbers) for range formatting.
			-- { start = { line, col }, ['end'] = { line, col } }
			-- Conform automatically provides range formatting even if the underlying formatter doesn't support it.
			-- range = nil,
			-- id: Passed to `vim.lsp.buf.format()` when using LSP formatting.
			-- name: Passed to `vim.lsp.buf.format()` when using LSP formatting.
			-- filter: A function `fun(client: table): boolean` passed to `vim.lsp.buf.format()` when using LSP formatting.
		},

		-- format_on_save: If set, Conform will run formatters on `BufWritePre`.
		-- This can be a table of options (passed to `conform.format()`) or a function that returns a table.
		format_on_save = {
			-- I recommend these options for format-on-save:
			lsp_format = "fallback",
			timeout_ms = 1000, -- Give formatters enough time
			async = false, -- Typically want sync formatting on save for immediate feedback
			undojoin = true, -- Merge formatting changes with the save operation in undo history
		},

		-- format_after_save: If set, Conform will run formatters asynchronously after `BufWritePost`.
		-- This can be a table of options or a function.
		-- Use this if you want formatting to happen completely in the background without blocking saving.
		-- Note: If the buffer is modified again quickly, the formatting might be discarded.
		-- format_after_save = {
		--   lsp_format = "fallback",
		--   timeout_ms = 1000,
		--   async = true,
		--   undojoin = true, -- Still good practice for undo history
		-- },

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
			python = { "isort", "black" }, -- isort first, then black
			json = { "prettierd", "prettier", stop_after_first = true },
			yaml = { "prettierd", "prettier", stop_after_first = true },
			markdown = { "prettierd", "prettier", stop_after_first = true },
			sh = { "shfmt" },
			go = { "goimports", "gofmt" }, -- goimports first, then gofmt
			rust = { "rustfmt" },
			-- Add more filetypes and their preferred formatters here
			-- For example, for C/C++ with clang-format:
			-- c = { "clang-format" },
			-- cpp = { "clang-format" },
		},

		-- formatters: Define or override specific formatter configurations.
		-- This is where you can pass arguments to formatters, set custom commands, etc.
		formatters = {
			-- Example: Customizing `stylua`
			stylua = {
				-- command: The command to execute (defaults to the formatter's name if not specified)
				-- command = "stylua",
				-- args: A list of strings, or a function that returns a list of strings.
				-- These are arguments passed to the formatter command.
				-- You can use "magic strings" like `$FILENAME`, `$DIRNAME`, `$RELATIVE_FILEPATH`, `$EXTENSION`.
				-- args = { "--search-parent-directories", "$FILENAME" },

				-- prepend_args: Add these arguments to the *beginning* of the command's args.
				-- Useful if you want to add common flags without completely redefining `args`.
				-- prepend_args = { "--check-format" }, -- Example for a dry-run check

				-- stdin: If true, the buffer content is passed to the formatter via stdin.
				-- Most formatters support this. If false, Conform writes the buffer to a temporary file.
				stdin = true,

				-- cwd: A function that calculates the directory to run the command in.
				-- Defaults to `require("conform.util").root_file` which finds the project root.
				-- You can set your own logic, e.g., always run in the current buffer's directory:
				-- cwd = function(bufnr) return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":h") end,
				-- Or find a specific file:
				-- cwd = require("conform.util").root_file({ ".git", ".editorconfig", "package.json" }),

				-- require_cwd: When `cwd` is not found, don't run the formatter (default `false`).
				-- require_cwd = true,

				-- tmp_file_template: When `stdin=false`, use this template to generate the temporary file.
				-- This can be a string or a function returning a string.
				-- Useful if the formatter cares about the temporary file's name/extension.
				-- tmp_file_template = "$FILENAME.tmp",

				-- env: A table of environment variables to set for the formatter process.
				-- env = { MY_ENV_VAR = "some_value" },

				-- inherit: Set to `false` to disable merging this config with the base definition.
				-- If `true` (default), your custom settings will be merged with Conform's built-in defaults for that formatter.
				inherit = true,

				-- range_args: A function `fun(start_line, end_line): string[]` that returns arguments for range formatting.
				-- Conform automatically handles range formatting if the formatter doesn't support it directly.
				-- This is for formatters that *do* support it.
				-- range_args = function(start_line, end_line)
				--   return { "--line-range", tostring(start_line), tostring(end_line) }
				-- end,

				-- diagnosis_to_errors: A function to parse formatter stderr output into a list of diagnostic errors.
				-- Defaults to a basic parser, but can be customized for specific formatter outputs.
				-- diagnosis_to_errors = function(bufnr, output)
				--   -- return table of { message = "...", line = ..., col = ... }
				-- end,

				-- -- Example of a custom formatter not built into conform:
				-- my_custom_formatter = {
				--   command = "my_custom_tool",
				--   args = { "--format", "$FILENAME" },
				--   stdin = false, -- If it needs a file path directly
				-- },
			},

			-- Customizing prettier/prettierd for specific options:
			prettierd = {
				-- Prettier (and prettierd) often use config files like `.prettierrc`.
				-- You can pass specific options via args if needed.
				-- For example, to ensure trailing commas:
				-- args = { "--stdin-filepath", "$FILENAME", "--trailing-comma", "all" },
				-- Or to force a parser if it's not inferred correctly:
				-- options = {
				--   ft_parsers = {
				--     javascript = "babel",
				--     javascriptreact = "babel",
				--     typescript = "typescript",
				--     typescriptreact = "typescript",
				--   }
				-- }
			},

			-- Customizing rustfmt:
			rustfmt = {
				-- options = {
				--   -- The default edition of Rust to use when no Cargo.toml file is found
				--   default_edition = "2021",
				-- },
			},

			-- Customizing injected (for formatting code blocks within markdown, etc.):
			injected = {
				-- Set to true to ignore errors from injected formatters (default: false)
				-- options = {
				--   ignore_errors = false,
				--   -- Map of treesitter language to filetype (for temporary file creation if stdin=false)
				--   lang_to_ft = { bash = "sh", },
				--   -- Map of treesitter language to file extension (for temporary file creation if stdin=false)
				--   lang_to_ext = { bash = "sh", c_sharp = "cs", },
				--   -- Map of treesitter language to formatters to use (defaults to value from `formatters_by_ft`)
				--   lang_to_formatters = { json = { "jq" } },
				-- },
			},

			-- Add configurations for other formatters as needed, e.g., for `clang-format`:
			-- ["clang-format"] = {
			--   -- Example: Use a specific style
			--   args = { "--style=Google" },
			--   -- Or from a file
			--   -- args = { "--style=file" },
			-- },
		},
	},
}
