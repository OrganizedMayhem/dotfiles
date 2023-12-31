local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
  -- Plugin manager
  use 'wbthomason/packer.nvim'  
  -- Appearance plugins
  use 'ellisonleao/gruvbox.nvim'
  use 'dracula/vim'
  use { "catppuccin/nvim", as = "catppuccin" }
  use 'nvim-lualine/lualine.nvim'
  use 'nvim-treesitter/nvim-treesitter'
  use 'bluz71/vim-nightfly-colors'
  -- Functional plugins
  use 'tpope/vim-commentary'
  use 'lewis6991/gitsigns.nvim'
  use 'preservim/vimux'
  use 'christoomey/vim-tmux-navigator'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-surround'
  use 'stevearc/oil.nvim'
  -- Completion plugins
  use 'L3MON4D3/LuaSnip'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use { 'codota/tabnine-nvim', run = "./dl_binaries.sh" }
  -- LSP and related plugins
  use {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
  }

  -- Special plugins with post-install commands
  use {
    "iamcco/markdown-preview.nvim",
    run = "cd app && npm install",
  }
  --  use {
  --  "vinnymeller/swagger-preview.nvim",
  --  run = "npm install -g swagger-ui-watcher",
  -- }

  -- Versioned and dependency plugins
  use {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.3',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  -- If packer was bootstrapped, then sync it to install missing plugins
  require('tabnine').setup({
    disable_auto_comment=true,
    accept_keymap="<Tab>",
    dismiss_keymap = "<C-]>",
    debounce_ms = 800,
    suggestion_color = {gui = "#808080", cterm = 244},
    exclude_filetypes = {"TelescopePrompt", "NvimTree"},
    log_file_path = '/var/log/tabnine.log', -- absolute path to Tabnine log file
    })
  if packer_bootstrap then
    require('packer').sync()
  end
end)

