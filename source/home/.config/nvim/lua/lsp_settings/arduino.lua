require'lspconfig'.arduino_language_server.setup({
	cmd =  {
		-- Required
		os.getenv("HOME").."/.language-servers/arduino-language-server/arduino-language-server",
		"-cli-config", "~/.arduino15/arduino-cli.yaml",
		-- Optional
		-- "-cli", "/path/to/arduino-cli",
		-- "-clangd", "/path/to/clangd"
	}
})
