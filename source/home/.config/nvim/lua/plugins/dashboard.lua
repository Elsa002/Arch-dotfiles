local g = vim.g
local fn = vim.fn

if vim.fn.has("win32") == 1 then
  plugins_count = fn.len(fn.globpath("~/.local/share/nvim/site/pack/packer/start", "*", 0, 1))
else
  plugins_count = fn.len(fn.globpath("~/.local/share/nvim/site/pack/packer/start", "*", 0, 1))
end

g.dashboard_disable_statusline = 1
g.dashboard_default_executive = "telescope"

-- Generated with the ascii font: 'DOS Rebel' at 'https://manytools.org/hacker-tools/ascii-banner'.
g.dashboard_custom_header = {
" ██████   █████                   █████   █████  ███                 ",
"░░██████ ░░███                   ░░███   ░░███  ░░░                  ",
" ░███░███ ░███   ██████   ██████  ░███    ░███  ████  █████████████  ",
" ░███░░███░███  ███░░███ ███░░███ ░███    ░███ ░░███ ░░███░░███░░███ ",
" ░███ ░░██████ ░███████ ░███ ░███ ░░███   ███   ░███  ░███ ░███ ░███ ",
" ░███  ░░█████ ░███░░░  ░███ ░███  ░░░█████░    ░███  ░███ ░███ ░███ ",
" █████  ░░█████░░██████ ░░██████     ░░███      █████ █████░███ █████",
"░░░░░    ░░░░░  ░░░░░░   ░░░░░░       ░░░      ░░░░░ ░░░░░ ░░░ ░░░░░ "
}

g.dashboard_custom_section = {
    a = { description = { "  Find File                 SPC f f" }, command = "Telescope find_files" },
    b = { description = { "  Recents                   SPC f o" }, command = "Telescope oldfiles" },
    c = { description = { "  Find Word                 SPC f w" }, command = "Telescope live_grep" },
    d = { description = { "洛 New File                  SPC f n" }, command = "DashboardNewFile" },
    e = { description = { "  Bookmarks                 SPC b m" }, command = "Telescope marks" },
    f = { description = { "  Load Session              SPC l s" }, command = "Telescope sessions" },
    g = { description = { "  Load Last Session         No map " }, command = "LoadLastSession" }
}

g.dashboard_custom_footer = {
    " ",
    "NeoVim Loaded " .. plugins_count .. " plugins!  ",
    "Based on CodeArt v0.1"
}

-- Disable statusline and cursorline in dashboard.
vim.cmd("autocmd BufEnter * if &ft is \"dashboard\" | set laststatus=0 | else | set laststatus=2 | endif")
vim.cmd("autocmd BufEnter * if &ft is \"dashboard\" | set nocursorline | endif")
