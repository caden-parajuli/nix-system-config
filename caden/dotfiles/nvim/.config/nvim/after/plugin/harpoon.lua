local harpoon = require("harpoon")

harpoon:setup()

vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)

vim.keymap.set("n", "<C-k>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

-- QWERTY
-- vim.keymap.set("n", "<C-j>", function() harpoon:list():select(1) end)
-- vim.keymap.set("n", "<C-k>", function() harpoon:list():select(2) end)
-- vim.keymap.set("n", "<C-l>", function() harpoon:list():select(3) end)
-- vim.keymap.set("n", "<C-;>", function() harpoon:list():select(4) end)

-- Colemak
vim.keymap.set("n", "<C-n>", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<C-e>", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<C-i>", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<C-o>", function() harpoon:list():select(4) end)
vim.keymap.set("n", "<C-'>", function() harpoon:list():select(5) end)