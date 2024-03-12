require("obsidian").setup(
    {
        -- A list of workspace names, paths, and configuration overrides.
        -- If you use the Obsidian app, the 'path' of a workspace should generally be
        -- your vault root (where the `.obsidian` folder is located).
        workspaces = {
            {
                name = "Personal",
                path = "/home/sevans/vaults/personal"
            },
            {
                name = "Work",
                path = "/home/sevans/vaults/work"
            }
        },
        -- Alternatively - and for backwards compatibility - you can set 'dir' to a single path instead of
        -- 'workspaces'. For example:
        -- dir = "~/vaults/work",

        -- Optional, if you keep notes in a specific subdirectory of your vault.
        notes_subdir = "notes",
        -- Optional, set the log level for obsidian.nvim. This is an integer corresponding to one of the log
        -- levels defined by "vim.log.levels.*".
        daily_notes = {
            -- Optional, if you keep daily notes in a separate directory.
            folder = "notes/dailies",
            -- Optional, if you want to change the date format for the ID of daily notes.
            date_format = "%Y-%m-%d",
            -- Optional, if you want to change the date format of the default alias of daily notes.
            alias_format = "%B %-d, %Y",
            -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
            template = nil
        },
        -- Optional, completion of wiki links, local markdown links, and tags using nvim-cmp.
        completion = {
            nvim_cmp = true,
            min_chars = 3,
            use_path_only = false
        },
        new_notes_location = "current_dir",
        -- Optional, customize how names/IDs for new notes are created.
        wiki_link_func = function(opts)
            if opts.id == nil then
                return string.format("[[%s]]", opts.label)
            elseif opts.label ~= opts.id then
                return string.format("[[%s|%s]]", opts.id, opts.label)
            else
                return string.format("[[%s]]", opts.id)
            end
        end,
        -- Optional, for templates (see below).
        templates = {
            subdir = "templates",
            date_format = "%Y-%m-%d",
            time_format = "%H:%M",
            -- A map for custom variables, the key should be the variable and the value a function
            substitutions = {}
        },
        -- URL it will be ignored but you can customize this behavior here.
        follow_url_func = function(url)
            -- Open the URL in the default web browser.
            vim.fn.jobstart({"xdg-open", url}) -- linux
        end,
        -- Optional, set to true if you use the Obsidian Advanced URI plugin.
        -- https://github.com/Vinzent03/obsidian-advanced-uri
        use_advanced_uri = true,
        -- Optional, set to true to force ':ObsidianOpen' to bring the app to the foreground.
        open_app_foreground = false,
        -- Optional, by default commands like `:ObsidianSearch` will attempt to use
        -- telescope.nvim, fzf-lua, fzf.vim, or mini.pick (in that order), and use the
        -- first one they find. You can set this option to tell obsidian.nvim to always use this
        -- finder.
        finder = "telescope.nvim",
        -- Optional, configure key mappings for the finder. These are the defaults.
        -- If you don't want to set any mappings this way then set
        finder_mappings = {
            -- Create a new note from your query with `:ObsidianSearch` and `:ObsidianQuickSwitch`.
            -- Currently only telescope supports this.
            new = "<C-x>"
        },
        -- Optional, sort search results by "path", "modified", "accessed", or "created".
        -- The recommend value is "modified" and `true` for `sort_reversed`, which means, for example,
        -- that `:ObsidianQuickSwitch` will show the notes sorted by latest modified time
        sort_by = "modified",
        sort_reversed = true,
        -- Optional, determines how certain commands open notes. The valid options are:
        -- 1. "current" (the default) - to always open in the current window
        -- 2. "vsplit" - to open in a vertical split if there's not already a vertical split
        -- 3. "hsplit" - to open in a horizontal split if there's not already a horizontal split
        open_notes_in = "current",
        -- Optional, configure additional syntax highlighting / extmarks.
        -- This requires you have `conceallevel` set to 1 or 2. See `:help conceallevel` for more details.
        ui = {
            enable = true, -- set to false to disable all additional syntax features
            update_debounce = 200, -- update delay after a text change (in milliseconds)
            -- Define how various check-boxes are displayed
            checkboxes = {
                -- NOTE: the 'char' value has to be a single character, and the highlight groups are defined below.
                [" "] = {char = "󰄱", hl_group = "ObsidianTodo"},
                ["x"] = {char = "", hl_group = "ObsidianDone"},
                [">"] = {char = "", hl_group = "ObsidianRightArrow"},
                ["~"] = {char = "󰰱", hl_group = "ObsidianTilde"}
            },
            bullets = {char = "•", hl_group = "ObsidianBullet"},
            external_link_icon = {char = "", hl_group = "ObsidianExtLinkIcon"},
            reference_text = {hl_group = "ObsidianRefText"},
            highlight_text = {hl_group = "ObsidianHighlightText"},
            tags = {hl_group = "ObsidianTag"},
            hl_groups = {
                ObsidianTodo = {bold = true, fg = "#f78c6c"},
                ObsidianDone = {bold = true, fg = "#89ddff"},
                ObsidianRightArrow = {bold = true, fg = "#f78c6c"},
                ObsidianTilde = {bold = true, fg = "#ff5370"},
                ObsidianBullet = {bold = true, fg = "#89ddff"},
                ObsidianRefText = {underline = true, fg = "#c792ea"},
                ObsidianExtLinkIcon = {fg = "#c792ea"},
                ObsidianTag = {italic = true, fg = "#89ddff"},
                ObsidianHighlightText = {bg = "#75662e"}
            }
        },
        -- Specify how to handle attachments.
        attachments = {
            -- The default folder to place images in via `:ObsidianPasteImg`.
            -- If this is a relative path it will be interpreted as relative to the vault root.
            -- You can always override this per image by passing a full path to the command instead of just a filename.
            img_folder = "assets/imgs", -- This is the default
            -- A function that determines the text to insert in the note when pasting an image.
            -- It takes two arguments, the `obsidian.Client` and a plenary `Path` to the image file.
            -- This is the default implementation.
            ---@param client obsidian.Client
            ---@param path Path the absolute path to the image file
            ---@return string
            img_text_func = function(client, path)
                local link_path
                local vault_relative_path = client:vault_relative_path(path)
                if vault_relative_path ~= nil then
                    -- Use relative path if the image is saved in the vault dir.
                    link_path = vault_relative_path
                else
                    -- Otherwise use the absolute path.
                    link_path = tostring(path)
                end
                local display_name = vim.fs.basename(link_path)
                return string.format("![%s](%s)", display_name, link_path)
            end
        },
        -- Optional, set the YAML parser to use. The valid options are:
        --  * "native" - uses a pure Lua parser that's fast but potentially misses some edge cases.
        --  * "yq" - uses the command-line tool yq (https://github.com/mikefarah/yq), which is more robust
        --    but much slower and needs to be installed separately.
        -- In general you should be using the native parser unless you run into a bug with it, in which
        -- case you can temporarily switch to the "yq" parser until the bug is fixed.
        yaml_parser = "yq"
    }
)
