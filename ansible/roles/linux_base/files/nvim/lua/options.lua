require("nvchad.options")

local o = vim.opt

-- Your custom options
o.autoindent = true
o.expandtab = true
o.history = 1000
o.listchars = "tab:>-,trail:~,extends:>,precedes:<"
o.relativenumber = true
o.shiftwidth = 0
o.shiftround = true
o.spell = true
o.tabstop = 4
o.termguicolors = true
o.wildmenu = true
o.wildmode = "longest,list"
o.wrap = false

-- %% expands to current directory path
vim.cmd([[
  cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'
]])

-- Line numbers (must use vim.opt to override NvChad defaults)
o.number = true -- Show absolute line number on current line
o.relativenumber = true -- Show relative line numbers
o.cursorline = true -- Highlight current line
o.signcolumn = "yes" -- Always show sign column (for breakpoints, git, etc.)
o.numberwidth = 4 -- Width of line number column
