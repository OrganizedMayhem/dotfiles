local vim = vim
vim.g.mapleader = " "
vim.g.maplocalleader = " "
-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true
vim.opt.conceallevel = 2
-- Make line numbers default
vim.opt.number = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
-- vim.opt.relativenumber = true
vim.opt.fileencoding = "utf-8"
vim.opt.fileformat = unix
-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = "a"

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

vim.schedule(function()
    vim.opt.clipboard = "unnamedplus"
end)

-- Enable break indent
vim.opt.breakindent = false

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = {
    tab = "» ",
    trail = "·",
    nbsp = "␣"
}

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, {
    desc = "Open diagnostic [Q]uickfix list"
})

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", {
    desc = "Exit terminal mode"
})

vim.keymap.set("n", "<C-h>", "<C-w><C-h>", {
    desc = "Move focus to the left window"
})
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", {
    desc = "Move focus to the right window"
})
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", {
    desc = "Move focus to the lower window"
})
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", {
    desc = "Move focus to the upper window"
})

vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("kickstart-highlight-yank", {
        clear = true
    }),
    callback = function()
        vim.highlight.on_yank()
    end
})

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({"git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath})
    if vim.v.shell_error ~= 0 then
        error("Error cloning lazy.nvim:\n" .. out)
    end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({"tpope/vim-sleuth", {
    "lewis6991/gitsigns.nvim",
    opts = {
        signs = {
            add = {
                text = "+"
            },
            change = {
                text = "~"
            },
            delete = {
                text = "_"
            },
            topdelete = {
                text = "‾"
            },
            changedelete = {
                text = "~"
            }
        }
    }
}, {
    import = "custom.plugins"
},
{
    import = "custom.options"
},
{
    import = "custom.language_server_settings"
},{
    import = "custom.format"
},
{
    import = "custom.autocomplete"
}

})
