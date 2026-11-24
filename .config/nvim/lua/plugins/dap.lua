return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio", -- required by nvim-dap-ui
			"leoluz/nvim-dap-go", -- go adapter (uses delve from mason)
			"mfussenegger/nvim-dap-python", -- python adapter (uses debugpy from mason)
		},
		keys = {
			{ "<F5>",       function() require("dap").continue() end,          desc = "Debug: Start/Continue" },
			{ "<F10>",      function() require("dap").step_over() end,         desc = "Debug: Step Over" },
			{ "<F11>",      function() require("dap").step_into() end,         desc = "Debug: Step Into" },
			{ "<F12>",      function() require("dap").step_out() end,          desc = "Debug: Step Out" },
			{ "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
			{
				"<leader>dB",
				function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end,
				desc = "Conditional Breakpoint",
			},
			{ "<leader>dc", function() require("dap").continue() end,          desc = "Start/Continue" },
			{ "<leader>dC", function() require("dap").run_to_cursor() end,     desc = "Run to Cursor" },
			{ "<leader>dl", function() require("dap").run_last() end,          desc = "Run Last" },
			{ "<leader>dr", function() require("dap").repl.toggle() end,       desc = "Toggle REPL" },
			{ "<leader>dt", function() require("dap").terminate() end,         desc = "Terminate" },
			{ "<leader>du", function() require("dapui").toggle() end,          desc = "Toggle Debug UI" },
			{ "<leader>de", function() require("dapui").eval() end,            desc = "Eval",                  mode = { "n", "v" } },
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			dapui.setup()
			require("dap-go").setup()
			require("dap-python").setup(vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python")

			-- Breakpoint signs
			vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
			vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn" })
			vim.fn.sign_define("DapBreakpointRejected", { text = "○", texthl = "DiagnosticHint" })
			vim.fn.sign_define("DapLogPoint", { text = "◉", texthl = "DiagnosticInfo" })
			vim.fn.sign_define("DapStopped", { text = "→", texthl = "DiagnosticOk", linehl = "Visual" })

			-- Open/close the UI automatically and refresh the statusline DAP indicator
			dap.listeners.after.event_initialized["user_config"] = function()
				dapui.open()
				vim.cmd("redrawstatus")
			end
			dap.listeners.before.event_terminated["user_config"] = function()
				dapui.close()
				vim.cmd("redrawstatus")
			end
			dap.listeners.before.event_exited["user_config"] = function()
				dapui.close()
				vim.cmd("redrawstatus")
			end
		end,
	},
}
