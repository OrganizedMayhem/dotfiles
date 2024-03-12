-- Initialize Mason for managing external editor tooling
require("mason").setup()

-- Configure Mason-LSPConfig to automatically manage LSP servers, formatters, and linters
require("mason-lspconfig").setup(
    {
        -- Define the list of tools Mason should ensure are installed.
        -- This list includes LSP servers for various programming languages,
        -- as well as utilities for linting and formatting.
        ensure_installed = {
            -- Language Servers
            "lua_ls", -- Lua        -- Rust -- CMake
            "gopls", -- Go
            "python-lsp-server", -- Python
            "bash-language-server", -- Bash
            "terraform-ls", -- Terraform
            "yaml-language-server", -- YAML
            -- Linters
            "tflint", -- Terraform
            "ansible-lint", -- Ansible
            "checkstyle", -- Java
            "hadolint", -- Dockerfile
            "shellcheck", -- Shell scripts
            "staticcheck", -- Go static analysis
            -- Formatters
            "luaformatter", -- Lua
            -- Docker & Kubernetes
            "docker_compose_language_service",
            "dockerfile-language-server",
            "helm-ls",
            -- Commit & Code Style Linters
            "commitlint",
            "gitlint",
            -- Security & Static Analysis
            "tfsec" -- Terraform
        }

        -- Optional: Add additional Mason-LSPConfig options here for further customization
        -- For example, you can specify automatic installation settings, UI configurations, etc.
    }
)
