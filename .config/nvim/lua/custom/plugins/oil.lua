return {
    "stevearc/oil.nvim",
    config = function()
        require("oil").setup({
            default_file_explorer = true,
            columns = {"icon", "size"},
            buf_options = {
                buflisted = true,
                bufhidden = "hide"
            },
            delete_to_trash = false,
            skip_confirm_for_simple_edits = false,
            prompt_save_on_select_new_entry = true,
            cleanup_delay_ms = 2000,
            lsp_file_methods = {
                timeout_ms = 1000,
                autosave_changes = false
            },
            constrain_cursor = "editable",
            experimental_watch_for_changes = true,
            keymaps = {
                ["g?"] = "actions.show_help",
                ["<CR>"] = "actions.select",
                ["<C-s>"] = "actions.select_vsplit",
                ["<C-h>"] = "actions.select_split",
                ["<C-t>"] = "actions.select_tab",
                ["<C-p>"] = "actions.preview",
                ["<C-c>"] = "actions.close",
                ["<C-l>"] = "actions.refresh",
                ["-"] = "actions.parent",
                ["_"] = "actions.open_cwd",
                ["`"] = "actions.cd",
                ["~"] = "actions.tcd",
                ["gs"] = "actions.change_sort",
                ["gx"] = "actions.open_external",
                ["g."] = "actions.toggle_hidden",
                ["g\\"] = "actions.toggle_trash"
            },
            keymaps_help = {
                border = "rounded"
            },
            use_default_keymaps = true,
            view_options = {
                show_hidden = true,
                is_hidden_file = function(name, bufnr)
                    return vim.startswith(name, ".")
                end,
                is_always_hidden = function(name, bufnr)
                    return false
                end,
                natural_order = true,
                sort = {{"type", "asc"}, {"name", "asc"}}
            },
            float = {
                padding = 2,
                max_width = 0,
                max_height = 0,
                border = "rounded",
                win_options = {
                    winblend = 0
                },
                override = function(conf)
                    return conf
                end
            },
            preview = {
                max_width = 0.9,
                min_width = {40, 0.4},
                width = nil,
                max_height = 0.9,
                min_height = {5, 0.1},
                height = nil,
                border = "rounded",
                win_options = {
                    winblend = 0
                },
                update_on_cursor_moved = true
            },
            progress = {
                max_width = 0.9,
                min_width = {40, 0.4},
                width = nil,
                max_height = {10, 0.9},
                min_height = {5, 0.1},
                height = nil,
                border = "rounded",
                minimized_border = "none",
                win_options = {
                    winblend = 0
                }
            },
            ssh = {
                border = "rounded"
            }
        })
    end
}
