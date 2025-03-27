return {{
    "ray-x/sad.nvim",
    dependencies = {
        "ray-x/guihua.lua",
        run = "cd lua/fzy && make"
    },
    config = function()
        require("sad").setup({
            debug = false,
            diff = "delta",
            ls_file = "fd",
            exact = false,
            vsplit = false,
            height_ratio = 0.6,
            width_ratio = 0.6
        })
    end
}}
