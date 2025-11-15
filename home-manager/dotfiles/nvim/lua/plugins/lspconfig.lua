return {
	"neovim/nvim-lspconfig",
	config = function()
		vim.lsp.config("*", {})
		vim.lsp.enable({
			"rust_analyzer",
			"nushell",
		})
	end,
	keys = {
		{ "K", function() return vim.lsp.buf.hover() end, desc = "Hover" },
		{ "gd", vim.lsp.buf.definition, desc = "Goto Definition"},
		{ "gr", vim.lsp.buf.references, desc = "References", nowait = true },
		{ "<leader>cr", vim.lsp.buf.rename, desc = "Rename"},
		{ "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "x" } },
	},
}
