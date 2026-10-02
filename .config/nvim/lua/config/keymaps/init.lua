-- Keymap registry: every mapping lives in one of the group files below, tagged with the plugin
-- that provides it. The registry drives vim.keymap.set, the which-key groups/icons and the
-- snacks cheatsheet picker (<leader>sK / :Keymaps), so there is a single place to edit.
--
-- Entry fields:
--   [1] lhs, [2] rhs (string or function)   desc
--   mode     string|string[] (default "n")
--   plugin   overrides the group's plugin for this entry
--   toggle   function returning a Snacks.toggle; mapped with toggle:map(lhs)
--   lsp      set buffer-locally on LspAttach; `method` makes it conditional on server support
--   ref      documentation only (built-ins, plugin-internal keys); nothing is mapped
--   hidden   mapped, but kept out of which-key and the picker
--   nowait, silent   passed through to vim.keymap.set
--
-- Group fields: name, plugin, icon (which-key icon spec), prefixes ({ lhs = label }),
-- scope (entries are handed to a plugin's own config via M.plugin_keys instead of being mapped).
local M = {}

M.order = {
	"find",
	"search",
	"lsp",
	"git",
	"code",
	"nav",
	"ui",
	"tools",
	"completion",
	"oil",
	"obsidian",
}

---@return table[]
function M.groups()
	if not M._groups then
		M._groups = {}
		for _, id in ipairs(M.order) do
			local group = require("config.keymaps." .. id)
			group.id = id
			for _, entry in ipairs(group.maps) do
				entry.group = group
				entry.plugin = entry.plugin or group.plugin
				entry.mode = entry.mode or "n"
			end
			table.insert(M._groups, group)
		end
	end
	return M._groups
end

---@param fn fun(entry: table, group: table)
local function each(fn)
	for _, group in ipairs(M.groups()) do
		for _, entry in ipairs(group.maps) do
			fn(entry, group)
		end
	end
end

local function set(entry, extra)
	local opts = vim.tbl_extend("force", {
		desc = entry.desc,
		nowait = entry.nowait,
		silent = entry.silent,
	}, extra or {})
	vim.keymap.set(entry.mode, entry[1], entry[2], opts)
end

--- Applies all global mappings and toggles. Called from init.lua after plugins are set up.
function M.setup()
	each(function(entry, group)
		if group.scope or entry.ref or entry.lsp then
			return
		end
		if entry.toggle then
			entry.toggle():map(entry[1], { mode = entry.mode })
		else
			set(entry)
		end
	end)

	vim.api.nvim_create_user_command("Keymaps", function(args)
		require("config.keymaps.picker").open({ pattern = args.args })
	end, { nargs = "?", desc = "Keymap cheatsheet (snacks)" })
end

--- Buffer-local LSP mappings, called from the LspAttach autocmd.
---@param bufnr integer
---@param client vim.lsp.Client
function M.lsp_attach(bufnr, client)
	local wk_spec = {}
	each(function(entry, group)
		if not entry.lsp or (entry.method and not client:supports_method(entry.method, bufnr)) then
			return
		end
		set(entry, { buffer = bufnr, desc = "LSP: " .. entry.desc })
		table.insert(wk_spec, { entry[1], mode = entry.mode, buffer = bufnr, icon = entry.icon or group.icon })
	end)
	if package.loaded["which-key"] then
		require("which-key").add(wk_spec)
	end
end

--- Mappings for a plugin that takes them in its own config (e.g. oil's `keymaps` table).
---@param scope string
---@return table<string, any>
function M.plugin_keys(scope)
	local keys = {}
	each(function(entry, group)
		if group.scope == scope and not entry.ref then
			keys[entry[1]] = entry[2]
		end
	end)
	return keys
end

--- which-key spec: group labels for every prefix plus the group icon on each global mapping.
---@return wk.Spec
function M.which_key_spec()
	local spec = {}
	for _, group in ipairs(M.groups()) do
		for prefix, label in pairs(group.prefixes or {}) do
			table.insert(spec, { prefix, group = label, icon = group.icon })
		end
	end
	each(function(entry, group)
		if group.scope or entry.ref or entry.lsp or entry.toggle then
			return -- toggles register their own dynamic icons
		end
		if entry.hidden then
			table.insert(spec, { entry[1], mode = entry.mode, hidden = true })
		else
			table.insert(spec, { entry[1], mode = entry.mode, desc = entry.desc, icon = entry.icon or group.icon })
		end
	end)
	return spec
end

return M
