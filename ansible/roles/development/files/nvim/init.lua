-- ale
vim.g.ale_linters = {
    sh = { "shellcheck", },
    python = { "flake8" },
    dockerfile = { "hadolint" },
    terraform = { "terraform_ls" },
    markdown = { "vale" },
    nix = { "nix" },
    javascript = { "jsbeautify" },
}
vim.g.ale_fixers = {
    sh = { "shfmt", },
    python = { "isort", "black" },
    terraform = { "terraform" },
    nix = { "nixfmt" },
    javascript = { "jsbeautify" },
}
vim.g.ale_lint_on_enter = 1
vim.g.ale_fix_on_save = 1
vim.g.ale_lint_on_save = 1
vim.g.ale_fix_on_insert_leave = 1
vim.g.ale_lint_on_text_changed = 1
vim.g.ale_python_flake8_options = '--max-line-length=120'

vim.cmd([[set runtimepath^=~/.vim runtimepath+=~/.vim/after]])
vim.cmd([[set guicursor=]])
vim.cmd([[let &packpath = &runtimepath]])
vim.cmd([[source ~/.vimrc]])
