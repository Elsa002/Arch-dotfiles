require'lspconfig'.bashls.setup {
    cmd = { "bash-language-server", "start" },
    cmd_env = {
      GLOB_PATTERN = "*@(.sh|.inc|.bash|.command)"
    },
    filetypes = { "sh", "zsh" },
    -- root_dir = util.find_git_ancestor,
    single_file_support = true
}
