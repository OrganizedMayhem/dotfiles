vim.g.have_nerd_font = true
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.o.autoindent = true -- Keep identation from previous line
vim.o.breakindent = true
vim.o.conceallevel = 2
vim.o.cursorline = true
vim.o.expandtab = true -- Convert tabs to spaces
vim.o.ignorecase = true
vim.o.inccommand = "split"
vim.opt.listchars = {
	tab = "» ",
	trail = "·",
	nbsp = "␣",
}
vim.o.list = true
vim.o.mouse = "a"
vim.o.number = true
vim.o.relativenumber = true
vim.o.scrolloff = 10
vim.o.shiftwidth = 4
vim.o.showmode = false
vim.o.signcolumn = "yes"
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.softtabstop = 4
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.tabstop = 4
vim.o.timeoutlen = 300
vim.o.undofile = true
vim.o.updatetime = 250

-- 0.11+: default border for every floating window (hover, signature, diagnostics, plugins)
vim.o.winborder = "rounded"
-- 0.12+: border for the built-in popup menu
vim.o.pumborder = "rounded"

-- Folding: treesitter by default, upgraded to LSP folding on attach (see autocmds.lua).
-- Start with everything open so folds never surprise you.
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldtext = "" -- 0.10+: keep syntax highlighting on the fold line
vim.o.foldlevelstart = 99
