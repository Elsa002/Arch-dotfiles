-- Function for make mapping easier.
local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend("force", options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end


-- Map leader key to space.
vim.g.mapleader = " "


-- Set cl for clearing highlights after searching word in file.
map("n", "<Leader>h", ":noh<CR>")

-- Split navigations.
map("n", "<A-j>", "<C-w><C-j>")
map("n", "<A-k>", "<C-w><C-k>")
map("n", "<A-l>", "<C-w><C-l>")
map("n", "<A-h>", "<C-w><C-h>")

-- Set j and k to not skip lines.
map("n", "j", "gj")
map("n", "k", "gk")
map("n", "gj", "j")
map("n", "gk", "k")

-- Buffer resizing.
map("n", "<S-h>", ":call ResizeLeft(3)<CR><Esc>")
map("n", "<S-l>", ":call ResizeRight(3)<CR><Esc>")
map("n", "<S-k>", ":call ResizeUp(1)<CR><Esc>")
map("n", "<S-j>", ":call ResizeDown(1)<CR><Esc>")

-- Buffer switching.
map("n", "<A-[>", ":BufferLineCyclePrev<CR>")
map("n", "<A-]>", ":BufferLineCycleNext<CR>")

-- Buffer closing.
map("n", "<Leader>bc", ":BufferLinePickClose<CR>")

-- Buffer moving.
map("n", "<Leader>bl", ":BufferLineMoveNext<CR>")
map("n", "<Leader>bh", "::BufferLineMovePrev<CR>")


-- NvimTree toggle
map("n", "<Leader>e", ":NvimTreeToggle<CR>")

-- Tagbar Toggle
map("n", "<Leader>R", ":Tagbar<CR>")


-- Telescop.
map("n", "<Leader>fw", ":Telescope live_grep<CR>")
map("n", "<Leader>gt", ":Telescope git_status<CR>")
map("n", "<Leader>cm", ":Telescope git_commits<CR>")
map("n", "<Leader>ff", ":Telescope find_files<CR>")
map("n", "<Leader>fp", ":Telescope media_files<CR>")
map("n", "<Leader>fb", ":Telescope buffers<CR>")
map("n", "<Leader>fh", ":Telescope help_tags<CR>")
map("n", "<Leader>fo", ":Telescope oldfiles<CR>")
-- map("n", "<Leader>th", ":Telescope colorscheme<CR>")
map("n", "<Leader>t", ":Telescope<CR>")


-- Dashboard
map("n", "<Leader>db", ":Dashboard<CR>")
map("n", "<Leader>fn", ":DashboardNewFile<CR>")
map("n", "<Leader>bm", ":DashboardJumpMarks<CR>")
map("n", "<C-s>", ":w<CR>")
map("n", "<C-a>", ":wa<CR>")
map("i", "<C-s>", "<Esc>:w<CR>a")
map("i", "<C-a>", "<Esc>:wa<CR>a")


-- Lsp
map("n", "<Leader>,", ":lua vim.lsp.diagnostic.goto_prev()<CR>")
map("n", "<Leader>;", ":lua vim.lsp.diagnostic.goto_next()<CR>")
map("n", "<Leader>a", ":lua vim.lsp.buf.code_action()<CR>")
map("n", "<Leader>gd", ":lua vim.lsp.buf.definition()<CR>")
map("n", "<Leader>f", ":lua vim.lsp.buf.formatting()<CR>")
map("n", "<Leader>k", ":lua vim.lsp.buf.hover()<CR>")
map("n", "<Leader>m", ":lua vim.lsp.buf.rename()<CR>")
map("n", "<Leader>r", ":lua vim.lsp.buf.references()<CR>")
map("n", "<Leader>s", ":lua vim.lsp.buf.document_symbol()<CR>")


-- ToggleTerm
map("n", "<C-t>", ":ToggleTerm<CR>")
map("t", "<C-t>", "<C-\\><C-n>:ToggleTerm<CR>")
map("n", "v:count1 <C-t>", ":v:count1" .. "\"ToggleTerm\"<CR>")
map("v", "v:count1 <C-t>", ":v:count1" .. "\"ToggleTerm\"<CR>")
function _G.set_terminal_keymaps()
  map("t", "<esc>", "<C-\\><C-n>")
  map("t", "<C-q>", "<esc>")

  map("t", "<A-h>", "<c-\\><c-n><c-w>h")
  map("t", "<A-j>", "<c-\\><c-n><c-w>j")
  map("t", "<A-k>", "<c-\\><c-n><c-w>k")
  map("t", "<A-l>", "<c-\\><c-n><c-w>l")

  -- map("t", "<S-h>", "<c-\\><C-n>:call ResizeLeft(3)<CR>")
  -- map("t", "<S-j>", "<c-\\><C-n>:call ResizeDown(1)<CR>")
  -- map("t", "<S-k>", "<c-\\><C-n>:call ResizeUp(1)<CR>")
  -- map("t", "<S-l>", "<c-\\><C-n>:call ResizeRight(3)<CR>")
end
vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")


-- Remove unnecessary white spaces.
map("n", "<Leader>rs", ":StripWhitespace<CR>")


-- TrueZen focus mode.
map("n", "<Leader>fs", ":TZFocus<CR>")


-- Toggle fold.
map("n", "<Leader>ft", "za")


-- comment
map("n", "ct", ":CommentToggle<CR>")
-- map("v", "ct", ":'<,'>CommentToggle<CR>")
map("n", "<C-_>", ":CommentToggle<CR>")
map("v", "<C-_>", ":'<,'>CommentToggle<CR>")

-- Choose a session to load
map("n", "<Leader>ls", ":Telescope sessions<CR>")

-- Luasnip maps
vim.api.nvim_set_keymap("i", "<C-l>", "<Plug>luasnip-next-choice", {})
vim.api.nvim_set_keymap("s", "<C-l>", "<Plug>luasnip-next-choice", {})
vim.api.nvim_set_keymap("i", "<C-h>", "<Plug>luasnip-prev-choice", {})
vim.api.nvim_set_keymap("s", "<C-h>", "<Plug>luasnip-prev-choice", {})
