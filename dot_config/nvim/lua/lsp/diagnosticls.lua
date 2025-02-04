local utils = require("lsp.utils")

require("lspconfig").diagnosticls.setup({
	capabilities = utils.capabilities,
	flags = utils.default_flags,
	on_attach = utils.on_attach,

	filetypes = { "javascript", "typescript" },
	init_options = {
		linters = {
			eslint = {
				command = "./node_modules/.bin/eslint",
				rootPatterns = { ".eslintrc.js", ".eslintrc", ".git" },
				debounce = 100,
				args = {
					"--stdin",
					"--stdin-filename",
					"%filepath",
					"--format",
					"json",
				},
				sourceName = "eslint",
				parseJson = {
					errorsRoot = "[0].messages",
					line = "line",
					column = "column",
					endLine = "endLine",
					endColumn = "endColumn",
					message = "[eslint] ${message} [${ruleId}]",
					security = "severity",
				},
				securities = {
					[2] = "error",
					[1] = "warning",
				},
			},
		},
		filetypes = {
			javascript = "eslint",
			typescript = "eslint",
		},
	},
})
