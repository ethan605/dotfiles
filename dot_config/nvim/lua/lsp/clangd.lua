local utils = require("lsp.utils")

require("lspconfig").clangd.setup({
	capabilities = utils.capabilities,
	flags = utils.default_flags,
	on_attach = utils.on_attach,

	--cmd = { "/opt/homebrew/opt/llvm/bin/clangd", "--clang-tidy" },
	settings = {
		clangd = {
			InlayHints = {
				Designators = true,
				Enabled = true,
				ParameterNames = true,
				DeducedTypes = true,
			},
			fallbackFlags = { "-std=c++20" },
		},
	},
})
