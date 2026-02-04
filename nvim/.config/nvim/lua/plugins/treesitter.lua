
-- =========================
-- Install plugins
-- =========================

vim.pack.add({
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
		version = "v0.9.2",
	},
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
		version = "v0.9.2",
	},
})

-- =========================
-- Load plugins
-- =========================

vim.cmd("packadd nvim-treesitter")
vim.cmd("packadd nvim-treesitter-textobjects")

-- =========================
-- Configure Treesitter
-- =========================

require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"lua",
		"rust",
		"c",
		"cpp",
		"bash",
		"json",
		"toml",
	},

	highlight = { enable = true },
	indent = { enable = true },

	textobjects = {
		select = {
			enable = true,
			lookahead = true,
			keymaps = {
				["af"] = "@function.outer",
				["if"] = "@function.inner",
			},
		},
	},
})

-- Folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldenable = false
