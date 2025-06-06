local swap_dir = vim.fn.stdpath("data") .. "/swap"
if vim.fn.isdirectory(swap_dir) == 0 then
	vim.fn.mkdir(swap_dir, "p", "0o700")
end

require("config.options")
require("core.lazy")
require("core.lsp")
require("config.keymaps")
require("config.autocmds")
