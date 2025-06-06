return {{
    "saghen/blink.cmp",
    dependencies = {"L3MON4D3/LuaSnip"},
    opts = {
        keymap = {
            preset = "default",
            ["<C-space>"] = {"show", "show_documentation", "hide_documentation"},
            ["<C-e>"] = {"hide"},
            ["<CR>"] = {"accept", "fallback"},
            ["<Tab>"] = {function(cmp)
                local luasnip = require("luasnip")
                if cmp.is_visible() then
                    return cmp.select_next()
                elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                else
                    return cmp.fallback()
                end
            end, "fallback"},
            ["<S-Tab>"] = {function(cmp)
                local luasnip = require("luasnip")
                if cmp.is_visible() then
                    return cmp.select_prev()
                elseif luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    return cmp.fallback()
                end
            end, "fallback"}
        },

        sources = {
            default = {"lsp", "path", "snippets", "buffer"},
            -- Prioritize LSP for import statements
            providers = {
                lsp = {
                    name = "LSP",
                    module = "blink.cmp.sources.lsp",
                    -- Increase priority for import-like contexts
                    score_offset = 1000
                }
            }
        },

        completion = {
            accept = {
                auto_brackets = {
                    enabled = true
                }
            },
            menu = {
                draw = {
                    treesitter = {"lsp"},
                    -- Show more context in completion menu
                    columns = {{"kind_icon"}, {
                        "label",
                        "label_description",
                        gap = 1
                    }}
                }
            },
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 100 -- Faster documentation
            },
            -- Trigger completion more aggressively for imports
            trigger = {
                prefetch_on_insert = true,
                show_on_insert_on_trigger_character = true
            }
        },

        signature = {
            enabled = true
        },

        snippets = {
            expand = function(snippet)
                require("luasnip").lsp_expand(snippet)
            end,
            active = function(filter)
                return require("luasnip").in_snippet()
            end,
            jump = function(direction)
                local luasnip = require("luasnip")
                if direction == 1 then
                    luasnip.jump(1)
                else
                    luasnip.jump(-1)
                end
            end
        }
    }
}, -- Completion engine: blink.cmp
{
    "saghen/blink.cmp",
    dependencies = {"L3MON4D3/LuaSnip"},
    version = '1.*',
    opts = {
        keymap = {
            preset = "default",
            ["<C-space>"] = {"show", "show_documentation", "hide_documentation"},
            ["<C-e>"] = {"hide"},
            ["<CR>"] = {"accept", "fallback"},
            ["<Tab>"] = {function(cmp)
                local luasnip = require("luasnip")
                if cmp.is_visible() then
                    return cmp.select_next()
                elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                else
                    return cmp.fallback()
                end
            end, "fallback"},
            ["<S-Tab>"] = {function(cmp)
                local luasnip = require("luasnip")
                if cmp.is_visible() then
                    return cmp.select_prev()
                elseif luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    return cmp.fallback()
                end
            end, "fallback"}
        },
        snippets = {
            expand = function(snippet)
                require("luasnip").lsp_expand(snippet)
            end,
            active = function(filter)
                return require("luasnip").in_snippet()
            end,
            jump = function(direction)
                local luasnip = require("luasnip")
                if direction == 1 then
                    luasnip.jump(1)
                else
                    luasnip.jump(-1)
                end
            end
        },
        sources = {
            default = {"lsp", "path", "snippets", "buffer"}
        },
        completion = {
            accept = {
                auto_brackets = {
                    enabled = true
                }
            },
            menu = {
                draw = {
                    treesitter = {"lsp"}
                }
            },
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 200
            }
        },
        signature = {
            enabled = true
        }
    }
}, {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
    dependencies = {"rafamadriz/friendly-snippets"},
    config = function()
        local luasnip = require("luasnip")

        -- Load snippets from friendly-snippets
        require("luasnip.loaders.from_vscode").lazy_load()

        -- Key mappings for snippet navigation
        vim.keymap.set({"i", "s"}, "<C-k>", function()
            if luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            end
        end, {
            silent = true
        })

        vim.keymap.set({"i", "s"}, "<C-j>", function()
            if luasnip.jumpable(-1) then
                luasnip.jump(-1)
            end
        end, {
            silent = true
        })

        vim.keymap.set("i", "<C-l>", function()
            if luasnip.choice_active() then
                luasnip.change_choice(1)
            end
        end)
    end
}}
