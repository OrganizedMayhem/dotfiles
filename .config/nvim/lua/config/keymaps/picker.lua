-- Snacks picker over the keymap registry, listed in group order.
-- <CR> runs the mapping (normal-mode ones) or jumps to its definition otherwise;
-- <C-e> always jumps to where it is defined.
local M = {}

local function modes(entry)
	return type(entry.mode) == "table" and table.concat(entry.mode) or entry.mode
end

--- Line of `{ "<lhs>"` in the group file, so previews and <C-e> land on the definition.
local function locate(file, lhs, cache)
	cache[file] = cache[file] or vim.fn.readfile(file)
	local needle = "{ " .. ("%q"):format(lhs)
	for lnum, line in ipairs(cache[file]) do
		if line:find(needle, 1, true) then
			return lnum
		end
	end
	return 1
end

local function items()
	local ret, cache = {}, {}
	for _, group in ipairs(require("config.keymaps").groups()) do
		local file = vim.api.nvim_get_runtime_file("lua/config/keymaps/" .. group.id .. ".lua", false)[1]
		for _, entry in ipairs(group.maps) do
			if not entry.hidden then
				local scope = group.scope and (group.scope .. " buffer")
					or entry.lsp and "lsp buffer"
					or entry.ref and "reference"
					or nil
				table.insert(ret, {
					entry = entry,
					group = group,
					scope = scope,
					file = file,
					pos = { locate(file, entry[1], cache), 0 },
					text = table.concat({ group.name, entry.plugin, modes(entry), entry[1], entry.desc, scope or "" }, " "),
				})
			end
		end
	end
	return ret
end

local function format(item)
	local a = Snacks.picker.util.align
	local entry, ret = item.entry, {}
	local icon, icon_hl
	if package.loaded["which-key"] then
		icon, icon_hl = require("which-key.icons").get(item.group.icon)
	end
	ret[#ret + 1] = { a(icon or "", 3), icon_hl }
	ret[#ret + 1] = { a(item.group.name, 11), "SnacksPickerLabel" }
	ret[#ret + 1] = { a(entry.plugin, 23), "SnacksPickerSpecial" }
	ret[#ret + 1] = { a(modes(entry), 4), "SnacksPickerKeymapMode" }
	ret[#ret + 1] = { a(Snacks.util.normkey(entry[1]), 16), "SnacksPickerKeymapLhs" }
	ret[#ret + 1] = { entry.desc or "", entry.ref and "SnacksPickerComment" or "SnacksPickerDesc" }
	if item.scope then
		ret[#ret + 1] = { "  " .. item.scope, "SnacksPickerComment" }
	end
	return ret
end

local function edit_source(picker, item)
	picker:close()
	vim.cmd.edit(vim.fn.fnameescape(item.file))
	vim.api.nvim_win_set_cursor(0, item.pos)
end

---@param opts? snacks.picker.Config
function M.open(opts)
	return Snacks.picker(vim.tbl_deep_extend("force", {
		title = "Keymaps",
		items = items(),
		format = format,
		preview = "file",
		sort = { fields = { "score:desc", "idx" } }, -- keep registry order until you type
		confirm = function(picker, item)
			if not item then
				return
			end
			local entry = item.entry
			local runnable = not (entry.ref or item.group.scope)
				and vim.list_contains(type(entry.mode) == "table" and entry.mode or { entry.mode }, "n")
			if not runnable then
				return edit_source(picker, item)
			end
			picker:close()
			vim.schedule(function()
				vim.api.nvim_feedkeys(vim.keycode(entry[1]), "m", false)
			end)
		end,
		actions = { edit_source = edit_source },
		win = {
			input = { keys = { ["<C-e>"] = { "edit_source", mode = { "n", "i" }, desc = "Edit definition" } } },
		},
	}, opts or {}))
end

return M
