vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
	callback = function(event)
		local bufnr = event.buf
		local client = assert(vim.lsp.get_client_by_id(event.data.client_id))
		local methods = vim.lsp.protocol.Methods

		-- Built-in defaults (no need to map): K hover, grn rename, gra code action,
		-- grr references, gri implementation, grt type definition, gO document symbols,
		-- <C-s> signature help (insert). See :h lsp-defaults
		require("config.keymaps").lsp_attach(bufnr, client)

		-- Symbol-under-cursor highlighting is handled by snacks.words.

		if client:supports_method(methods.textDocument_foldingRange, bufnr) then
			local win = vim.api.nvim_get_current_win()
			vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
		end

		if client:supports_method(methods.textDocument_codeLens, bufnr) then
			vim.lsp.codelens.enable(true, { bufnr = bufnr })
		end

		if client:supports_method(methods.textDocument_linkedEditingRange, bufnr) then
			vim.lsp.linked_editing_range.enable(true, { client_id = client.id })
		end
	end,
})
