-- Flutter/Dart用LSPサーバー設定
---@type vim.lsp.Config
return {
	cmd = { 'dart', 'language-server', '--protocol=lsp' },
	filetypes = { 'dart' },
	root_markers = { 'pubspec.yaml', '.git' },
	settings = {
		dart = {
			completeFunctionCalls = true,
			showTodos = true,
		}
	}
}
