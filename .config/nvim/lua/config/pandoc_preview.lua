-- Render the current markdown buffer through `pandoc` into a floating
-- preview window, kept live as the source buffer changes.

local M = {}

---@type table<integer, {win: integer, buf: integer, augroup: integer, gen: integer}>
local state = {}

local function render(src_buf, preview_buf, gen, entry)
	if not vim.api.nvim_buf_is_valid(src_buf) or not vim.api.nvim_buf_is_valid(preview_buf) then
		return
	end

	local lines = vim.api.nvim_buf_get_lines(src_buf, 0, -1, false)
	local input = table.concat(lines, "\n")

	vim.system(
		{ "pandoc", "-f", "markdown", "-t", "plain", "--wrap=auto" },
		{ stdin = input, text = true },
		function(result)
			vim.schedule(function()
				if entry.gen ~= gen then
					return -- a newer render was requested in the meantime
				end
				if not vim.api.nvim_buf_is_valid(preview_buf) then
					return
				end
				local out
				if result.code == 0 then
					out = vim.split(result.stdout or "", "\n", { plain = true })
				else
					out = { "pandoc failed:", "" }
					vim.list_extend(out, vim.split(result.stderr or "", "\n", { plain = true }))
				end
				vim.bo[preview_buf].modifiable = true
				vim.api.nvim_buf_set_lines(preview_buf, 0, -1, false, out)
				vim.bo[preview_buf].modifiable = false
			end)
		end
	)
end

local function schedule_render(src_buf)
	local entry = state[src_buf]
	if not entry then
		return
	end
	entry.gen = entry.gen + 1
	local gen = entry.gen
	vim.defer_fn(function()
		render(src_buf, entry.buf, gen, entry)
	end, 150)
end

local function close(src_buf)
	local entry = state[src_buf]
	if not entry then
		return
	end
	state[src_buf] = nil
	pcall(vim.api.nvim_del_augroup_by_id, entry.augroup)
	if vim.api.nvim_win_is_valid(entry.win) then
		vim.api.nvim_win_close(entry.win, true)
	end
	if vim.api.nvim_buf_is_valid(entry.buf) then
		vim.api.nvim_buf_delete(entry.buf, { force = true })
	end
end

local function open(src_buf)
	if vim.fn.executable("pandoc") == 0 then
		vim.notify("pandoc_preview: `pandoc` not found on PATH", vim.log.levels.ERROR)
		return
	end

	local preview_buf = vim.api.nvim_create_buf(false, true)
	vim.bo[preview_buf].buftype = "nofile"
	vim.bo[preview_buf].swapfile = false
	vim.bo[preview_buf].bufhidden = "wipe"
	vim.bo[preview_buf].filetype = "text"

	local width = math.floor(vim.o.columns * 0.6)
	local height = math.floor(vim.o.lines * 0.8)
	local win = vim.api.nvim_open_win(preview_buf, false, {
		relative = "editor",
		width = width,
		height = height,
		row = math.floor((vim.o.lines - height) / 2),
		col = math.floor((vim.o.columns - width) / 2),
		border = "rounded",
		title = " Pandoc Preview ",
		title_pos = "center",
		style = "minimal",
	})
	vim.wo[win].wrap = true
	vim.wo[win].linebreak = true

	for _, lhs in ipairs({ "q", "<Esc>" }) do
		vim.keymap.set("n", lhs, function()
			close(src_buf)
		end, { buffer = preview_buf, nowait = true })
	end

	local augroup = vim.api.nvim_create_augroup("PandocPreview" .. src_buf, { clear = true })
	vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "BufWritePost" }, {
		group = augroup,
		buffer = src_buf,
		callback = function()
			schedule_render(src_buf)
		end,
	})
	vim.api.nvim_create_autocmd("BufWipeout", {
		group = augroup,
		buffer = src_buf,
		callback = function()
			close(src_buf)
		end,
	})
	vim.api.nvim_create_autocmd("WinClosed", {
		group = augroup,
		pattern = tostring(win),
		callback = function()
			close(src_buf)
		end,
	})

	state[src_buf] = { win = win, buf = preview_buf, augroup = augroup, gen = 0 }
	schedule_render(src_buf)
end

function M.toggle()
	local src_buf = vim.api.nvim_get_current_buf()
	if state[src_buf] then
		close(src_buf)
	else
		open(src_buf)
	end
end

return M
