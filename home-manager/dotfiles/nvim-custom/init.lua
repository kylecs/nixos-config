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

-- spacing settings
vim.opt.smartindent = true
-- vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- persist undo info after closing nvim
vim.opt.undofile = true

-- show inline diagnostics
vim.diagnostic.config({ virtual_text = true })

-- Save on C-s
vim.keymap.set({'n', 'v', 's'}, '<C-s>', ':update<CR>', { silent = true, desc = 'Save File' })
vim.keymap.set('i', '<C-s>', '<C-O>:update<CR>', { silent = true, desc = 'Save File and Stay in Insert Mode' })

-- lazy
require("config.lazy")
