:colorscheme molokai

let g:flake8_ignore="E501,W503,E203"  " ignore certain flake8 errors from Black

call pathogen#infect()
filetype off
syntax on
filetype plugin indent on


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"       SETTINGS OF ALL SORTES
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" * Leader
let mapleader = ","

set autoread

" Why even have a GUI?
set guioptions=

" Tabs
if version >= 703
    set relativenumber             " shows line numbers relative to current line
else
    set number
endif
set list                           "show tabs and newlines
set tabstop=4                      "set tab to 4 spaces
set softtabstop=4                  "set soft tab to 4 spaces
set shiftwidth=4
set expandtab                      "soft tabs (as spaces)
set background=dark
colorscheme molokai

" Basics
set ruler
set nocompatible
set modelines=0
syntax on                          " syntax highlighting is nifty! let's turn it on!
set showmode                       " display the current mode in the status line
set showcmd                        " show partially-typed commands in the status line
set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " a ruler on steroids
set hidden                         " autohide modified buffers when I navigate away from them
set undofile                       "create a file containing undo changes

" * General Options
set history=1000                   " keeps a thousand lines of history
set magic                          " allows pattern matching with special characters
set backspace=2                    " make backspace work like normal
set visualbell                     " visual bell instead of annoying beeping
set cursorline                     " hightlight line cursor
set mouse=a                        " enable full mouse support in the console
set virtualedit=onemore            " allow for cursor beyond last character
" * Search & Replace
set ignorecase                     " make searches case-insensitive
set smartcase                      " unless they contain upper-case letters ;)
set incsearch                      " show the `best match so far' as search strings are typed
set gdefault                       " assume the /g flag on :s substitutions
set hlsearch                       " highlight search items

set wrap linebreak textwidth=9999  " set vim to soft wrap lines
set colorcolumn=120
set formatoptions=qrn1
set autoindent
set shiftround

set wildmenu                       " enables tab completion at the bottom of the vim/gvim window
set wildmode=longest,list          " complete on tab to longest match, present match list on second tab
set ttyfast                        " enable support for higher speed terminal connections
set showmatch                      " show brace matching
set matchtime=3                    " for 3 milliseconds
set scrolloff=4

set wildchar=<TAB>            " have command-line completion <Tab>
set whichwrap=h,l,~,[,]       " have the h and l cursor keys wrap between
                              " lines (like <Space> and <BkSpc> do by default),
                              " and ~ convert case over line breaks;
                              " also have the cursor keys wrap in insert mode
" invisible characters to show
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
" get rid of the default style of C comments, and define a style with two stars
" at the start of `middle' rows which (looks nicer and) avoids asterisks used
" for bullet lists being treated like C comments; then define a bullet list
" style for single stars (like already is for hyphens):
set comments-=s1:/*,mb:*,ex:*/
set comments+=s:/*,mb:\ *,ex:*/
set comments+=fb:\ *
" treat lines starting with a quote mark as comments (for 'Vim' files)
set comments+=b:\"
" OmniCompletion for std lib functions and so forth (C-X, C-o)
set omnifunc=syntaxcomplete#Complete

" Statusline Hijinx
set statusline=%f       "tail of the filename
"display a warning if fileformat isnt unix
set statusline+=%#warningmsg#
set statusline+=%{&ff!='unix'?'['.&ff.']':''}
set statusline+=%*
"display a warning if file encoding isnt utf-8
set statusline+=%#warningmsg#
set statusline+=%{(&fenc!='utf-8'&&&fenc!='')?'['.&fenc.']':''}
set statusline+=%*
set statusline+=%h      "help file flag
set statusline+=%y      "filetype
set statusline+=%r      "read only flag
set statusline+=%m      "modified flag
" fugitive statusline
set statusline+=%{exists('g:loaded_fugitive')?fugitive#statusline():''}
"display a warning if &et is wrong, or we have mixed-indenting
set statusline+=%#error#
set statusline+=%{StatuslineTabWarning()}
set statusline+=%*
set statusline+=%{StatuslineTrailingSpaceWarning()}
set statusline+=%{StatuslineLongLineWarning()}
set statusline+=%#warningmsg#
set statusline+=%*
"display a warning if &paste is set
set statusline+=%#error#
set statusline+=%{&paste?'[paste]':''}
set statusline+=%*
set statusline+=%=      "left/right separator
set statusline+=%{StatuslineCurrentHighlight()}\ \ "current highlight
set statusline+=%c,     "cursor column
set statusline+=%l/%L   "cursor line/total lines
set statusline+=\ %P    "percent through file
set laststatus=2        "always show status line

set path+=./**          "set path to the cwd and all child dirs

set nofixendofline

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"       KEYMAPPINGS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" %% in command mode expands to the path of the active buffer
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" turn on 'very magic' mode (full regex support when searching)
nnoremap / /\v
vnoremap / /\v
"ctrl swtiches between splits
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
",w to open new vertical split window
",e to open new horizontal split window
nnoremap <leader>w <C-w>v<C-w>l
nnoremap <leader>e <C-w>s<C-w>l
" use <F6> to cycle through split windows (and <Shift>+<F6> to cycle backwards
nnoremap <F6> <C-W>w
nnoremap <S-F6> <C-W>W
" Yank from the cursor to the end of the line, to be consistent with C and D.
nnoremap Y y$
" Sudo to write (for those pesky 'write-protected files')
cmap w!! w !sudo tee % >/dev/null
" unhighilight search items with ,<space>
nnoremap <leader><space> :noh<cr>
" toggle invisible characters
nnoremap <leader>l :set list!<cr>
" enter insert mode after paste
nmap <leader>p pi
" edit vim config in a new tab
nmap <leader>V :tabnew $MYVIMRC<CR>
" page down with <Space>, page up with backspace
noremap <Space> <PageDown>
noremap <BS> <PageUp>
" disable help key.
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>
" save about 500 keypresses/day (shift key)
" this messes with the actuql ; command (repeat last f/F command - is there a better way?)
nnoremap ; :
" disable arrows (saves right hand from moving to and from arrows)
noremap <Up> <nop>
noremap <Down> <nop>
noremap <Left> <nop>
noremap <Right> <nop>
" j and k operate on visual lines by default
nnoremap j gj
nnoremap k gk
"jj to enter normal mode (saves left hand from moving from home row to ESC and back)
inoremap jj <ESC>
" bind current to scroll
nnoremap <leader>s :set scb!<CR>
" strip trailing whitespace from entire file
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>
" change all leading tabs to 4 spaces
nnoremap <leader>T :%s/\t/    /<cr>:let @/=''<CR>
"next/prev tabs
nnoremap <leader>. :tabn<cr>
nnoremap <leader>, :tabp<cr>
"close tab
nnoremap <leader>c :close<cr>
"toggle relative numbering
nnoremap <leader>rn :set relativenumber!<cr>
" Easier linewise reselection
map <leader>v V`]
nnoremap <silent> <leader>y "+y
" highlight long lines in file
nnoremap <leader>long :HighlightLongLines<CR>
"sort CSS properties
nnoremap <leader>S ?{<CR>jV/^\s*\}?$<CR>k:sort<CR>:noh<CR>
" close all sorts of brackets automatically
inoremap {      {}<Left>
inoremap {<CR>  {<CR>}<Esc>O
inoremap {{     {
inoremap {}     {}
inoremap [      []<Left>
inoremap [<CR>  [<CR>]<Esc>O
inoremap [[     [
inoremap []     []
inoremap (      ()<Left>
inoremap (<CR>  (<CR>)<Esc>O
inoremap ((     (
inoremap ()     ()
inoremap "      ""<Left>
inoremap "<CR>  "<CR>"<Esc>O
inoremap ""     "
inoremap '      ''<Left>
inoremap '<CR>  '<CR>'<Esc>O
inoremap ''     '

" switch these since I learned them backwards
nnoremap # *
nnoremap * #

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"           AUTO COMMANDS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"save on window unfocus - never hit :wa again!
au FocusLost * :wa

" special syntaxes
au BufNewFile,BufRead *.as set filetype=actionscript
au BufNewFile,BufRead *.scala set filetype=scala
au BufNewFile,BufRead *.less set filetype=css
au BufNewFile,BufRead *.m set filetype=objc_enhanced
au BufNewFile,BufRead *.mm set filetype=objc_enhanced

" fold html tags
au BufNewFile,BufRead *.html map <leader>ft Vatzf

"highlight trailing whitespace - Thanks @kbourgoin!
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" * Text Formatting -- Specific File Formats
" recognize anything at all with a .txt extension as being human-language text
augroup filetype
  autocmd BufNewFile,BufRead *.txt set filetype=human
augroup END
autocmd FileType mail,human,markdown set formatoptions+=t textwidth=120
" for C-like programming, have automatic indentation:
autocmd FileType c,cpp,slang set cindent
" for actual C (not C++) programming where comments have explicit end
" characters, if starting a new line in the middle of a comment automatically
" insert the comment leader characters:
autocmd FileType c set formatoptions+=ro
" for Perl programming, have things in braces indenting themselves:
autocmd FileType perl set smartindent
" in makefiles, don't expand tabs to spaces, since actual tab characters are
" needed, and have indentation at 8 chars to be sure that all indents are tabs
" (despite the mappings later):
autocmd FileType make set noexpandtab shiftwidth=8

" ** PHP Specific
" highlights interpolated variables in sql strings and does sql-syntax highlighting. yay
autocmd FileType php let php_sql_query = 1
" does exactly that. highlights html inside of php strings
autocmd FileType php let php_htmlInStrings = 1
" discourages use oh short tags. c'mon its deprecated remember
autocmd FileType php let php_noShortTags = 1
" automagically folds functions & methods. this is getting IDE-like isn't it?
"autocmd FileType php let php_folding = 3
" highlight functions from the base library
autocmd FileType php let php_baselib = 1

" Automatic PHP syntax check
autocmd FileType php nmap <leader>pc :!php -l %<cr>

" open PHP classes but not functions
autocmd FileType php set foldlevel=1

map <silent> <F11> :call system("wmctrl -ir " . v:windowid . " -b toggle,fullscreen")<CR>

autocmd BufWritePost *.py call Flake8()
autocmd BufWritePre *.py call BlackCustom()
autocmd BufWritePost *.js call JsBeautifyCustom()


"recalculate the trailing whitespace warning when idle, and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_trailing_space_warning
"recalculate the tab warning flag when idle and after writing
autocmd cursorhold,bufwritepost * unlet! b:statusline_tab_warning

"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"           YE OLDE FUNCTIONS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if has("gui_running")
  if has("gui_gtk2")
    set guifont=Inconsolata\ 13
  elseif has("gui_macvim")
    set guifont=Menlo\ Regular:h14
  elseif has("gui_win32")
    set guifont=Consolas:h11:cANSI
  endif
endif

"define :HighlightLongLines command to highlight the offending parts of
"lines that are longer than the specified length (defaulting to 120)
command! -nargs=? HighlightLongLines call s:HighlightLongLines('<args>')
function! s:HighlightLongLines(width)
    let targetWidth = a:width != '' ? a:width : 119
    if targetWidth > 0
        exec 'match Todo /\%>' . (targetWidth) . 'v/'
    else
        echomsg "Usage: HighlightLongLines [natural number]"
    endif
endfunction

"return '[\s]' if trailing white space is detected
"return '' otherwise
function! StatuslineTrailingSpaceWarning()
    if !exists("b:statusline_trailing_space_warning")

        if !&modifiable
            let b:statusline_trailing_space_warning = ''
            return b:statusline_trailing_space_warning
        endif

        if search('\s\+$', 'nw') != 0
            let b:statusline_trailing_space_warning = '[\s]'
        else
            let b:statusline_trailing_space_warning = ''
        endif
    endif
    return b:statusline_trailing_space_warning
endfunction

"return the syntax highlight group under the cursor ''
function! StatuslineCurrentHighlight()
    let name = synIDattr(synID(line('.'),col('.'),1),'name')
    if name == ''
        return ''
    else
        return '[' . name . ']'
    endif
endfunction

"return '[&et]' if &et is set wrong
"return '[mixed-indenting]' if spaces and tabs are used to indent
"return an empty string if everything is fine
function! StatuslineTabWarning()
    if !exists("b:statusline_tab_warning")
        let b:statusline_tab_warning = ''

        if !&modifiable
            return b:statusline_tab_warning
        endif

        let tabs = search('^\t', 'nw') != 0

        "find spaces that arent used as alignment in the first indent column
        let spaces = search('^ \{' . &ts . ',}[^\t]', 'nw') != 0

        if tabs && spaces
            let b:statusline_tab_warning =  '[mixed-indenting]'
        elseif (spaces && !&et) || (tabs && &et)
            let b:statusline_tab_warning = '[&et]'
        endif
    endif
    return b:statusline_tab_warning
endfunction

"recalculate the long line warning when idle and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_long_line_warning

"return a warning for "long lines" where "long" is either &textwidth or 120 (if
"no &textwidth is set)
"
"return '' if no long lines
"return '[#x,my,$z] if long lines are found, were x is the number of long
"lines, y is the median length of the long lines and z is the length of the
"longest line
function! StatuslineLongLineWarning()
    if !exists("b:statusline_long_line_warning")

        if !&modifiable
            let b:statusline_long_line_warning = ''
            return b:statusline_long_line_warning
        endif

        let long_line_lens = s:LongLines()

        if len(long_line_lens) > 0
            let b:statusline_long_line_warning = "[" .
                        \ '#' . len(long_line_lens) . "," .
                        \ 'm' . s:Median(long_line_lens) . "," .
                        \ '$' . max(long_line_lens) . "]"
        else
            let b:statusline_long_line_warning = ""
        endif
    endif
    return b:statusline_long_line_warning
endfunction

"return a list containing the lengths of the long lines in this buffer
function! s:LongLines()
    let threshold = (&tw ? &tw : 120)
    let spaces = repeat(" ", &ts)

    let long_line_lens = []

    let i = 1
    while i <= line("$")
        let len = strlen(substitute(getline(i), '\t', spaces, 'g'))
        if len > threshold
            call add(long_line_lens, len)
        endif
        let i += 1
    endwhile

    return long_line_lens
endfunction

"find the median of the given array of numbers
function! s:Median(nums)
    let nums = sort(a:nums)
    let l = len(nums)

    if l % 2 == 1
        let i = (l-1) / 2
        return nums[i]
    else
        return (nums[l/2] + nums[(l/2)-1]) / 2
    endif
endfunction

" toggle quickfix window
command -bang -nargs=? QFix call QFixToggle(<bang>0)
function! QFixToggle(forced)
  if exists("g:qfix_win") && a:forced == 0
    cclose
    unlet g:qfix_win
  else
    copen 10
    let g:qfix_win = bufnr("$")
  endif
endfunction
nmap <silent> \ :QFix<CR>

" handle different Black configurations per repo
function! BlackCustom()
  if expand("%:p") =~ "\/dash\/"
    let g:black_linelength = 120
  else
    let g:black_linelength = 88
  endif
  execute ":Black"
endfunction

function! JsBeautifyCustom()
  if expand("%:p") =~ "\/parsely\-js\/"
    let result = system('~/opt/bin/jsbeautify ' . expand("%:p"))
    if result !~ "unchanged$"
      execute ":e!"
    endif
  endif
endfunction
