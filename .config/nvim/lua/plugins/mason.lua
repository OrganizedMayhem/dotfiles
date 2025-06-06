return {
    "mason-org/mason.nvim",
    opts = {
        -- The directory in which to install packages.
        install_root_dir = vim.fn.stdpath("data") .. "/mason",

        -- Where Mason should put its bin location in your PATH. Can be one of:
        -- - "prepend" (default, Mason's bin location is put first in PATH)
        -- - "append" (Mason's bin location is put at the end of PATH)
        -- - "skip" (doesn't modify PATH)
        PATH = "prepend",

        -- Controls to which degree logs are written to the log file. It's useful to set this to vim.log.levels.DEBUG when
        -- debugging issues with package installations.
        log_level = vim.log.levels.INFO,

        -- Limit for the maximum amount of packages to be installed at the same time. Once this limit is reached, any further
        -- packages that are requested to be installed will be put in a queue.
        max_concurrent_installers = 4,

        -- [Advanced setting]
        -- The registries to source packages from. Accepts multiple entries. Should a package with the same name exist in
        -- multiple registries, the registry listed first will be used.

        -- The provider implementations to use for resolving supplementary package metadata (e.g., all available versions).
        -- Accepts multiple entries, where later entries will be used as fallback should prior providers fail.

        pip = {
            -- Whether to upgrade pip to the latest version in the virtual environment before installing packages.
            upgrade_pip = true,

            -- Example: { "--proxy", "https://proxyserver" }
            install_args = {}
        },

        ui = {
            -- Whether to automatically check for new versions when opening the :Mason window.
            check_outdated_packages_on_open = true,

            -- The border to use for the UI window. Accepts same border values as |nvim_open_win()|.
            -- Defaults to `:h 'winborder'` if nil.
            border = "rounded",

            -- The backdrop opacity. 0 is fully opaque, 100 is fully transparent.
            backdrop = 60,

            -- Width of the window. Accepts:
            -- - Integer greater than 1 for fixed width.
            -- - Float in the range of 0-1 for a percentage of screen width.
            width = 0.8,

            -- Height of the window. Accepts:
            -- - Integer greater than 1 for fixed height.
            -- - Float in the range of 0-1 for a percentage of screen height.
            height = 0.9,

            icons = {
                -- The list icon to use for installed packages.
                package_installed = "✓",
                -- The list icon to use for packages that are installing, or queued for installation.
                package_pending = "➜",
                -- The list icon to use for packages that are not installed.
                package_uninstalled = "✗"
            },

            keymaps = {
                -- Keymap to expand a package
                toggle_package_expand = "<CR>",
                -- Keymap to install the package under the current cursor position
                install_package = "i",
                -- Keymap to reinstall/update the package under the current cursor position
                update_package = "u",
                -- Keymap to check for new version for the package under the current cursor position
                check_package_version = "c",
                -- Keymap to update all installed packages
                update_all_packages = "U",
                -- Keymap to check which installed packages are outdated
                check_outdated_packages = "C",
                -- Keymap to uninstall a package
                uninstall_package = "X",
                -- Keymap to cancel a package installation
                cancel_installation = "<C-c>",
                -- Keymap to apply language filter
                apply_language_filter = "<C-f>",
                -- Keymap to toggle viewing package installation log
                toggle_package_install_log = "<CR>",
                -- Keymap to toggle the help view
                toggle_help = "g?"
            }
        }
    },
}
