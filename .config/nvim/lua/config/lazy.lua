-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({"git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath})
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({{"Failed to clone lazy.nvim:\n", "ErrorMsg"}, {out, "WarningMsg"},
                           {"\nPress any key to exit..."}}, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

require("config.options")

-- Setup lazy.nvim
require("lazy").setup({
    -- The 'spec' table should contain all your plugin configurations.
    -- Each plugin is an element in this table.
    spec = { -- import your plugins (assuming 'plugins' is a directory or file returning a list of plugin specs)
    {
        import = "plugins"
    }, {
        "olimorris/onedarkpro.nvim",
        priority = 1000, -- Ensure it loads first
        -- You should set the colorscheme *after* the plugin is loaded and configured.
        -- Using the 'config' function is the correct way to do this with lazy.nvim.
        config = function()
            vim.cmd("colorscheme onedark")
        end
    }}, -- This curly brace closes the 'spec' table.

    -- These are options for lazy.nvim itself, not part of the 'spec' table.
    -- They should be at the same level as 'spec'.
    checker = {
        enabled = true -- automatically check for plugin updates
    }
})

require("config.keymaps")
