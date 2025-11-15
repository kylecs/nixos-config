-- number and sign columns
vim.opt.number = true
vim.o.signcolumn = 'yes'

-- keep cursor around center
vim.o.scrolloff = 10

-- sync buffers automatically
vim.opt.autoread = true

-- disable neovim generating a swapfile and showing the error
vim.opt.swapfile = false

-- use system clipboard
vim.opt.clipboard = "unnamedplus"

-- fearless leaders
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- tab settings
vim.opt.smartindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- persist undo info after closing nvim
vim.opt.undofile = true

-- show inline diagnostics
vim.diagnostic.config({ virtual_text = true })

-- lazy
require("config.lazy")
