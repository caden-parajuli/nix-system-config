vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>')
vim.keymap.set("n", "<leader>av", "<cmd>Oil<CR>")

-- Moving code around
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Center on movement
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Paste over without changing yank buffer
vim.keymap.set("x", "<leader>p", [["_dP]])

-- yank to system clipboard, from asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

vim.keymap.set("n", "<M-n>", "<cmd>cnext<CR>")
vim.keymap.set("n", "<M-p>", "<cmd>cprev<CR>")

-- Bad habits
vim.keymap.set("i", "<C-c>", "<Esc>")

-- Colemak (C-o is used for Harpoon, and C-y is physically the same as C-o on QWERTY)
vim.keymap.set("n", "<C-y>", "<C-o>")

-- Sessionizer
vim.keymap.set("n", "<M-m>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>ff", function()
    require("conform").format({ async = true, lsp_fallback = true })
end)

-- rename word
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
-- chmod +x current_file
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- like dot-emacs
vim.keymap.set("n", "<leader>vp", "<cmd>Oil ~/.config/nvim/lua/mine/<CR>")

-- stops highlighting of search
vim.keymap.set("n", "<leader>h", "<cmd>noh<CR>")

-- Neogen
vim.keymap.set("n", "<Leader>nf", ":lua require('neogen').generate()<CR>")

-- LuaSnip
vim.keymap.set('n', '<Leader>L', '<Cmd>lua require("luasnip.loaders.from_lua").load({paths = "~/.config/nvim/LuaSnip/"})<CR>')
