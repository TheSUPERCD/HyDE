require("nvchad.configs.lspconfig").defaults()

local servers = { "clangd", "rust_analyzer", "pylsp" }
vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers 
