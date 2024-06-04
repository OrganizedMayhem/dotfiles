local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({"git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path})
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

return require("packer").startup(function(use)
    -- Plugin manager
    use "wbthomason/packer.nvim"
    use {"williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim", "neovim/nvim-lspconfig"}
    -- Appearance plugins
    use "ellisonleao/gruvbox.nvim"
    use "dracula/vim"
    use "nvim-lualine/lualine.nvim"
    use "nvim-treesitter/nvim-treesitter"
    use "bluz71/vim-nightfly-colors"
    use "nvim-tree/nvim-web-devicons"
    use {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {}
    }
    -- Functional plugins
    use "tpope/vim-commentary"
    use "lewis6991/gitsigns.nvim"
    use "christoomey/vim-tmux-navigator"
    use "tpope/vim-fugitive"
    use "tpope/vim-surround"
    use({
        "stevearc/oil.nvim",
        requires = {"nvim-tree/nvim-web-devicons"}
    })
    -- Completion plugins
    use "L3MON4D3/LuaSnip"
    use "hrsh7th/nvim-cmp"
    use "hrsh7th/cmp-nvim-lsp"
    use "nvim-lua/plenary.nvim"
    use {
        "folke/which-key.nvim",
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
            require("which-key").setup {}
        end
    }
    use {"nvim-treesitter/playground"}
    use({
        "ray-x/sad.nvim",
        requires = {
            "ray-x/guihua.lua",
            run = "cd lua/fzy && make"
        },
        config = function()
            require("sad").setup {}
        end
    })
    use({
        "epwalsh/obsidian.nvim",
        tag = "*", -- recommended, use latest release instead of latest commit
        requires = { -- Required.
        "nvim-lua/plenary.nvim" -- see below for full list of optional dependencies 👇
        },
        config = function()
            require("obsidian").setup({
                workspaces = {{
                    name = "personal",
                    path = "~/vaults/Journal"
                }, {
                    name = "work",
                    path = "~/vaults/Notes"
                }}

                -- see below for full list of options 👇
            })
        end
    })
    use {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.x",
        requires = {{"nvim-lua/plenary.nvim"}}
    }
    use {
        "codota/tabnine-nvim",
        run = "./dl_binaries.sh"
    }

    if packer_bootstrap then
        require("packer").sync()
    end
end)
