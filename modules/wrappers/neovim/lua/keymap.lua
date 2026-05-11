local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<M-h>", "<C-w>h", opts)
vim.keymap.set("n", "<M-j>", "<C-w>j", opts)
vim.keymap.set("n", "<M-k>", "<C-w>k", opts)
vim.keymap.set("n", "<M-l>", "<C-w>l", opts)

vim.keymap.set("i", "<M-h>", "<Left>", opts)
vim.keymap.set("i", "<M-l>", "<Right>", opts)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", opts)
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", opts)

vim.keymap.set("n", "<A-w>", "<C-w><C-w>", opts)

vim.keymap.set("n", "z{", "zfi{", opts)
vim.keymap.set("n", "z(", "zfi(", opts)

vim.keymap.set("n", "<leader><esc>", "<cmd>:noh<return>", opts)

vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", opts)
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", opts)
vim.keymap.set("n", "<C-Up>", ":resize -2<CR>", opts)
vim.keymap.set("n", "<C-Down>", ":resize +2<CR>", opts)
vim.keymap.set("n", "<C-h>", ":vertical resize -2<CR>", opts)
vim.keymap.set("n", "<C-l>", ":vertical resize +2<CR>", opts)
vim.keymap.set("n", "<C-k>", ":resize -2<CR>", opts)
vim.keymap.set("n", "<C-j>", ":resize +2<CR>", opts)

vim.keymap.set("n", "<C-d>", "5<C-d>", opts)
vim.keymap.set("n", "<C-u>", "5<C-u>", opts)

-- Buffers
vim.keymap.set('n', '<Tab>', ':bnext<CR>', opts)
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', opts)
vim.keymap.set('n', '<leader><Tab>', ':b#<CR>', opts)
vim.keymap.set('n', '<leader>bn', ':enew<CR>', opts)
vim.keymap.set('n', '<leader>bd', ':bdelete<CR>', opts)
