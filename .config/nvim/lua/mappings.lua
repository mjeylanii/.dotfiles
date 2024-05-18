require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

local i = require("utils.keymap_util").inoremap
local n = require("utils.keymap_util").nnoremap
local t = require("utils.keymap_util").tnoremap
local v = require("utils.keymap_util").vnoremap
local x = require("utils.keymap_util").xnoremap
-- Explain the above functions
-- i = inoremap = insert mode keymap functions
-- n = nnoremap = normal mode keymap functions
-- t = tnoremap = terminal mode keymap functions
-- v = vnoremap = visual mode keymap functions
-- x = xnoremap = visual mode keymap functions

-- Configs
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

----------------------- Normal mode mappings (n) ----------------------------------------------
-- AutoSession
n("<leader>sr", "<cmd>SessionRestore<CR>", true, "Restore session")
n("<leader>ss", "<cmd>SessionSave<CR>", true, "Save session")

-- Bufferline
n("<leader>to", "<Cmd>BufferLinePick<CR>", true, "Pick buffer")
n("<leader>tp", "<Cmd>BufferLineTogglePin<CR>", true, "Toggle pin")
n("<leader>tcp", "<Cmd>BufferLineGroupClose ungrouped<CR>", true, "Delete non-pinned buffers")
n("<leader>tco", "<Cmd>BufferLineCloseOthers<CR>", true, "Delete other buffers")
n("<leader>tcr", "<Cmd>BufferLineCloseRight<CR>", true, "Delete buffers to the right")
n("<leader>tcl", "<Cmd>BufferLineCloseLeft<CR>", true, "Delete buffers to the left")
n("<leader>}", "<cmd>BufferLineCyclePrev<cr>", true, "Prev buffer")
n("<leader>{", "<cmd>BufferLineCycleNext<cr>", true, "Next buffer")

-- Diagnostics
n("<leader>dn", vim.diagnostic.goto_next, true, "Next diagnostic")
n("<leader>dp", vim.diagnostic.goto_prev, true, "Previous diagnostic")
n("<leader>de", vim.diagnostic.open_float, true, "Open diagnostic error messages")
n("<leader>df", vim.diagnostic.setloclist, true, "Open diagnostic quickfix list")

-- Noice
n("<leader>dm", "<cmd>NoiceDismiss<CR>", true, "Dissmiss Noice Message")

-- Harpoon
n("<leader>hm", "<cmd>lua require('harpoon.mark').add_file()<CR>", true, "Mark file with harpoon")
n("<leader>hn", "<cmd>lua require('harpoon.ui').nav_next()<CR>", true, "Go to next harpoon mark")
n("<leader>hp", "<cmd>lua require('harpoon.ui').nav_prev()<CR>", true, "Go to previous harpoon mark")
n("<leader>h1", "<cmd>lua require('harpoon.ui').nav_file(1)<CR>", true, "Go to harpoon marked 1")
n("<leader>h2", "<cmd>lua require('harpoon.ui').nav_file(2)<CR>", true, "Go to harpoon marked 2")
n("<leader>h3", "<cmd>lua require('harpoon.ui').nav_file(3)<CR>", true, "Go to harpoon marked 3")
n("<leader>h4", "<cmd>lua require('harpoon.ui').nav_file(4)<CR>", true, "Go to harpoon marked 4")
n("<leader>h5", "<cmd>lua require('harpoon.ui').nav_file(5)<CR>", true, "Go to harpoon marked 5")

-- LSP
n("<leader>D", "<cmd>lua vim.lsp.buf.definition()<CR>", true, "Go to definition")
n("<leader>RR", "<cmd>lua vim.lsp.buf.references()<CR>", true, "Go to references")
n("<leader>I", "<cmd>lua vim.lsp.buf.implementation()<CR>", true, "Go to implementation")
n("<leader>H", "<cmd>lua vim.lsp.buf.hover()<CR>", true, "Show hover")
n("<leader>S", "<cmd>lua vim.lsp.buf.signature_help()<CR>", true, "Show signature help")
n("<leader>TD", "<cmd>lua vim.lsp.buf.type_definition()<CR>", true, "Show type definition")
n("<leader>RN", "<cmd>lua vim.lsp.buf.rename()<CR>", true, "Rename")
n("<leader>A", "<cmd>lua vim.lsp.buf.code_action()<CR>", true, "Code action")
n("<leader>F", "vim.lsp.buf.formatting()", true, "Format")

-- Telescope
n("<leader>ff", "<cmd>Telescope find_files<CR>", true, "Find Files")
n("<leader>fr", "<cmd>Telescope oldfiles<CR>", true, "Find Recent Files")
n("<leader>fg", "<cmd>Telescope live_grep<CR>", true, "Live Grep")
n("<leader>fb", "<cmd>Telescope buffers<CR>", true, "Buffers")
n("<leader>fh", "<cmd>Telescope help_tags<CR>", true, "Help Tags")
n("<leader>fm", "<cmd>Telescope keymaps<CR>", true, "Find Key Maps")
n("<leader>gc", "<cmd>Telescope git_commits<CR>", true, "Commits")
n("<leader>gs", "<cmd>Telescope git_status<CR>", true, "Status")

-- Todo Comments
n("<leader>ft", "<cmd>TodoTelescope<CR>", true, "Find TODOs")
n("[t", "<cmd>require('todo-comments').jump_prev()<CR>", true, "Prev todo comment")
n("]t", "<cmd>require('todo-comments').jump_next()<CR>", true, "Next todo comment")

-- VimBeGood
n("<leader>l", "<cmd>VimBeGood<CR>", false, "Learn Vim")

-- VimMaximizer
n("<leader>mw", "<cmd>MaximizerToggle<CR>", true, "Maximize window")

----------------------- Insert mode mappings (i) --------------------------------------------

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
