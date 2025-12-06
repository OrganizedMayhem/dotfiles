-- Luacheck configuration for Neovim Lua development

-- Neovim globals
globals = {
    "vim",
    "jit",
}

-- Testing framework globals (if you use them)
read_globals = {
    "describe",
    "it",
    "before_each",
    "after_each",
    "pending",
    "setup",
    "teardown",
    "assert",
}

-- Ignore certain warnings
ignore = {
    "212", -- Unused argument
    "213", -- Unused loop variable
    "631", -- Line is too long
}

-- Set max line length
max_line_length = 120

-- Allow unused arguments in certain cases
unused_args = false

-- Allow unused secondary values of variables
unused_secondaries = false

-- Allow trailing whitespace (optional, you might want to keep this as true)
allow_defined_top = true

-- Exclude certain directories from checking
exclude_files = {
    ".luacheckrc",
    "tests/",
    "vendor/",
    "lua_modules/",
    ".rocks/",
}

-- Configure specific files or patterns
files["**/*_spec.lua"] = {
    std = "+busted",
}

files["init.lua"] = {
    globals = {
        "vim",
    },
}

-- Standard Lua version
std = "luajit"
