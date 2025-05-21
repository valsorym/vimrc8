" VIM 8 CONFIGURATIONS
" Author: valsorym <valsorym.e@gmail.com>
" Copyleft: 2012-2025

"'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"
"'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"
"''                                                                         ''"
"''                              EXPANSIONS                                 ''"
"''                                                                         ''"
"'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"
"'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"

"'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"
"'' SYSTEM                                                                  ''"
"'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"
" Variable prefix:
"   buffer-variable    b:     Local to the current buffer.
"   window-variable    w:     Local to the current window.
"   tabpage-variable   t:     Local to the current tab page.
"   global-variable    g:     Global.
"   local-variable     l:     Local to a function.
"   script-variable    s:     Local to a :source'ed Vim script.
"   function-argument  a:     Function argument (only inside a function).
"   vim-variable       v:     Global, predefined by Vim.
"
" - Use the rule to declare new variables.

" DebugMSG prints message in ~/.vimdebug.tmp file.
" Usage:
"   call DebugMSG("Some text for print here...")
function DebugMSG(message)
  silent execute '!echo '.a:message.' >> ~/.vimdebug.tmp'
endfunction

" IsTechBuffer returns true for technical buffers.
" Usage:
"   if IsTechBuffer(expand('%')) ...
function! IsTechBuffer(bufname, modifiable)
    let s:is_noname_buf = strlen(a:bufname) == 0
    let s:is_tagbar_buf = stridx(a:bufname, '__Tagbar__') == 0
    let s:is_nerdtree_buf = stridx(a:bufname, 'NERD_tree_') == 0
    let s:is_explorer_buf = stridx(a:bufname, '[BufExplorer]') == 0

    " Check rgrep buffer needs to be done without errors:
    let s:is_rgrep_buf = 0
    if bufexists(a:bufname)
        let l:lines = getbufline(bufname(a:bufname), 1, 1)
        if len(l:lines) > 0 && l:lines[0] =~# '|| \[Search'
            let s:is_rgrep_buf = 1
        endif
    endif

    let s:result = s:is_tagbar_buf || s:is_nerdtree_buf || s:is_explorer_buf || s:is_rgrep_buf

    if a:modifiable
        let s:result = s:result || (s:is_noname_buf && !&modifiable)
    else
        let s:result = s:result || s:is_noname_buf
    endif

    return s:result
endfunction


"'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"
"'' MAIN                                                                    ''"
"'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"
set shell=/bin/bash
let s:BASE_DIR=expand("~/.vim")

set t_ti=[?1049h
set t_te=[?1049l

function! ClearScreenOnExit()
  set t_ti=[?47h
  set t_te=[?47l
endfunction

autocmd BufWinLeave * call ClearScreenOnExit()

" TTY Fixes
if !has('gui_running')
    set t_RV=
    set t_ut=
endif

"'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"
"'' VUNDLE                                                                  ''"
"'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"
" USAGE:
"   :PluginInstall
"   :PluginUpdate
" DOC:
"   https://github.com/VundleVim/Vundle.vim
"
set nocompatible
filetype off
let &rtp .= ','.expand(s:BASE_DIR . '/bundle/Vundle.vim')
call vundle#begin(s:BASE_DIR . '/bundle')

" INSTALL VUNDLE.VIM
" VIM
"   $ git clone https://github.com/VundleVim/Vundle.vim.git \
"     ~/.vim/bundle/Vundle.vim
Plugin 'VundleVim/Vundle.vim'

" PLUGIN LIST:
Plugin 'valsorym/vim-tabs'
Plugin 'valsorym/vim-clear'
Plugin 'valsorym/vim-highlighting'
Plugin 'valsorym/vim-code-theme'

Plugin 'valsorym/rainglow-vim', {'name': 'vim'} " 'rainglow/vim'
Plugin 'valsorym/scrooloose-nerdtree', {'name': 'nerdtree'} " 'scrooloose/nerdtree'
Plugin 'valsorym/jistr-vim-nerdtree-tabs', {'name': 'vim-nerdtree-tabs'} " 'jistr/vim-nerdtree-tabs'
Plugin 'valsorym/jlanzarotta-bufexplorer', {'name': 'bufexplorer'} " 'jlanzarotta/bufexplorer'

Plugin 'valsorym/shougo-deoplete.nvim', {'name': 'deoplete.nvim'} " 'shougo/deoplete.nvim'
Plugin 'valsorym/roxma-nvim-yarp', {'name': 'nvim-yarp'} " 'roxma/nvim-yarp'
Plugin 'valsorym/roxma-vim-hug-neovim-rpc', {'name': 'vim-hug-neovim-rpc'} " 'roxma/vim-hug-neovim-rpc'

Plugin 'valsorym/chrisbra-colorizer', {'name': 'colorizer'} " 'chrisbra/colorizer'
Plugin 'valsorym/matze-vim-move', {'name': 'vim-move'} " 'matze/vim-move'
Plugin 'valsorym/elzr-vim-json', {'name': 'vim-json'} " 'elzr/vim-json'
Plugin 'valsorym/terryma-vim-multiple-cursors', {'name': 'vim-multiple-cursors'} " 'terryma/vim-multiple-cursors'

Plugin 'valsorym/posva-vim-vue', {'name': 'vim-vue'} " 'posva/vim-vue'
Plugin 'valsorym/vim-scripts-grep.vim', {'name': 'grep.vim'} " 'vim-scripts/grep.vim'
Plugin 'valsorym/preservim-tagbar', {'name': 'tagbar'} " 'preservim/tagbar'
Plugin 'valsorym/herringtondarkholme-yats.vim', {'name': 'yats.vim'} " 'herringtondarkholme/yats.vim'
Plugin 'valsorym/yuezk-vim-js', {'name': 'vim-js'} " 'yuezk/vim-js'
Plugin 'valsorym/maxmellon-vim-jsx-pretty', {'name': 'vim-jsx-pretty'} " 'maxmellon/vim-jsx-pretty'

Plugin 'valsorym/vim-matchup', {'name': 'vim-matchup'} " 'andymass/vim-matchup'

Plugin 'github/copilot.vim', {'name': 'copilot.vim'} " 'github/copilot.vim'

" Plugin 'fatih/vim-go', {'name': 'vim-go'} " 'fatih/vim-go' or 'govim/govim'
" Plugin 'valsorym/obcat-vim-sclow', {'name': 'vim-sclow'} " 'obcat/vim-sclow'

" :CocInstall coc-pyright coc-tsserver
Plugin 'neoclide/coc.nvim', {'branch': 'release'}

call vundle#end()
filetype plugin indent on


"'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"
"'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"
"''                                                                         ''"
"''                             BASE SETTINGS                               ''"
"''                                                                         ''"
"'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"
"'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"

"'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"
"'' MAIN                                                                    ''"
"'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"
" BACKUP AND SWAP FILES
set backup
set undodir=/tmp//
set backupdir=/tmp//
set directory=/tmp//

" INCOMPATIBILITY WITH VI
" Use the full capabilities of Vim without compatibility with vi.
set nocompatible      " Turn arrows in the mode of INSERT.

nnoremap <silent> <ESC>OA <UP>
nnoremap <silent> <ESC>OB <DOWN>
nnoremap <silent> <ESC>OC <RIGHT>
nnoremap <silent> <ESC>OD <LEFT>
inoremap <silent> <ESC>OA <UP>
inoremap <silent> <ESC>OB <DOWN>
inoremap <silent> <ESC>OC <RIGHT>
inoremap <silent> <ESC>OD <LEFT>

" BEEPING
" Disable beeping (aka 'bell') and window flashing, it works
" in both terminal and GUI mode.
set noerrorbells visualbell t_vb=
if has('autocmd')
  autocmd GUIEnter * set visualbell t_vb=
endif

" ENCODING SETTINGS
" UTF8 and type ending of line.
set termencoding=utf-8
set fileencodings=usc-bom,utf-8mdefault,cp1251
set ffs=unix,dos,mac
if has('multi_byte')
    set encoding=utf-8
    set fileencodings=utf-8,ucs-bom,latin1
    setglobal fileencoding=utf-8
    if &termencoding == ''
        let &termencoding=&encoding
    endif
endif

" COLOR SCHEME
" Editor color scheme.
syntax on
" set background=dark
colorscheme code

" Change cursorline for gVIM.
if $TERM != 'xterm-256color'
    " Different cursor styles in different buffers.
    " NERD_tree and Tagbar have a brighter cursor color when buffer is active,
    " and dim cursor color when focus is lost.
    " Main editor buffer has dim cursor color by default and hides the cursor
    " when buffer loses focus.
    augroup updateCursorLine
        autocmd!
        autocmd BufEnter,FocusGained,WinEnter,VimEnter,BufWinEnter,CmdwinEnter * call OnFocus()
    augroup END

    " Reset styles for some elements in active buffer.
    function! s:styleActiveBuffer()
        hi LineNr cterm=NONE ctermfg=30 ctermbg=16 gui=NONE guifg=#5c6574 guibg=#090a17
        hi CursorLineNr cterm=NONE ctermfg=226 ctermbg=38 gui=NONE guifg=#7c8884 guibg=#23343d
        hi Cursor cterm=NONE ctermfg=NONE ctermbg=38 gui=NONE guifg=NONE guibg=#004663
        hi CursorLine cterm=bold ctermfg=255 ctermbg=38 gui=bold guifg=#eeeeee guibg=#004663
        hi Search cterm=bold ctermfg=NONE ctermbg=NONE gui=bold guifg=NONE guibg=NONE
    endfunction

    " Reset styles for some elements in not active buffer.
    function! s:styleNoActiveBuffer()
        hi LineNr cterm=NONE ctermfg=30 ctermbg=16 gui=NONE guifg=#5c6574 guibg=#090a17
        hi CursorLineNr cterm=NONE ctermfg=NONE ctermbg=38 gui=NONE guifg=NONE guibg=#003a45
        hi Cursor cterm=NONE ctermfg=NONE ctermbg=38 gui=NONE guifg=NONE guibg=#3f3f3f
        hi CursorLine cterm=NONE ctermfg=NONE ctermbg=38 gui=NONE guifg=NONE guibg=#00202a
        hi Search cterm=bold ctermfg=NONE ctermbg=NONE gui=bold guifg=NONE guibg=NONE
    endfunction

    " On-focus event.
    function! OnFocus()
        "set lazyredraw
        if IsTechBuffer(bufname('%'), 1)
            setlocal cursorline
            call s:styleActiveBuffer()
        else
            setlocal nocursorline
            call s:styleNoActiveBuffer()
        endif
        "set nolazyredraw
    endfunction
endif


"'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"
"'' EDITOR                                                                  ''"
"'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"
" CONFIGS
" UpdateSource updates configurations of Vim.
function! UpdateSource() abort
    source ~/.vimrc | source ~/.gvimrc
endfunction
imap <C-A-r> <Esc>:call UpdateSource()<CR>
nmap <C-A-r> :call UpdateSource()<CR>

" TAB KEY SETTING
" Setting indentation when press the Tab key.
"     smarttab    when on, a <Tab> in front of a line inserts blanks
"                 according to 'shiftwidth'.  'tabstop' or 'softtabstop' is
"                 used in other places. A <BS> will delete a 'shiftwidth'
"                 worth of space at the start of the line;
"     expandtab   In Insert mode, use the appropriate number of spaces to
"                 insert a <Tab>. Spaces are used in indents with the '>' and
"                 '<' commands and when 'autoindent' is on. To insert a real
"                 tab when 'expandtab' is on, use CTRL-V<Tab>;
"     tabstop     magnitude of the indentation for Tab style;
"     softtabstop magnitude of the indentation for Space style;
"     shiftwidth  the number of spaces used in the indentation
"                 commands, such as >> or <<.
set smarttab
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

" COMMAND LINE
" Base settings.
set cmdheight=2
set completeopt+=menuone
set completeopt-=preview

" LINE NUMBERING
" Show line numbers in the file.
set number
" set number relativenumber
" set relativenumber
set numberwidth=5

" TITLE SETTINGS
" Custom title style.
set title
" let g:titlestring='set titlestring=VIM:\ %-25.55F titlelen=70'
let g:titlestring='set titlestring=VIM titlelen=70'
exec g:titlestring

" STATUSBAR SETTINGS
" Show pressed keys in normal mode.
set showcmd

" To display the status line always.
set laststatus=2

" Display typed commands in the status bar and make autocompletion using
" the <Tab> key. Always show the status of open file in the status bar.
set wildmenu

" STATUSLINE
" Colorize statusline.
" 1. Add color scheme into vim-theme:
"   hi STLNormalColor guifg=Black guibg=Green ctermbg=46 ctermfg=0
"   hi STLInsertColor guifg=Black guibg=Cyan ctermbg=51 ctermfg=0
"   hi STLReplaceColor guifg=Black guibg=maroon1 ctermbg=165 ctermfg=0
"   hi STLVisualColor guifg=Black guibg=Orange ctermbg=202 ctermfg=0
"
" 2. Use color-scheme:
"   set statusline+=%#STLNormalColor#%{(mode()=='n')?'\ \ \ ◎\ \ \ ':''}
"   set statusline+=%#STLInsertColor#%{(mode()=='i')?'\ \ \ ✎\ \ \ ':''}
"   set statusline+=%#STLReplaceColor#%{(mode()=='R')?'\ \ \ ✎\ \ \ ':''}
"   set statusline+=%#STLVisualColor#%{(mode()=='v')?'\ \ \ ✎\ \ \ ':''}

" FileWordCount returns string as <current word number>/<words count in file>.
function FileWordCount()
    let s:word_count=wordcount().words
    if has_key(wordcount(),'visual_words')
        let s:word_count=wordcount().visual_words."/".wordcount().words " count selected words
    else
        let s:word_count=wordcount().cursor_words."/".wordcount().words " or shows words 'so far'
    endif
    return s:word_count
endfunction

" FileReadOnly returns string 'r' for readonly file and 'rw' for any.
function FileReadOnly()
    return &readonly ? "r":"rw"
endfunc

" GitStatus returns git status.
" For example:
"   ⛓ master* - hasn't pushed to origin, master branch with uncommitted files.
"   master* - master branch with uncommitted files (pushed committed files);
"   master - master branch, pushed to origin;
"   etc...
function GitStatus()
    " Get git status.
    let s:status=substitute(system('git status -s'), '\n', '  |  ', 'g')
    if s:status=~'not a git repository'
                \ || s:status=~'fatal:'
                \ || s:status=~'command not found'
        return ''
    endif

    " Get current branch.
    let s:branch=substitute(
                \ system('git rev-parse --abbrev-ref HEAD'),
                \ '\n', '', 'g')

    " Check the number of modified files.
    let s:modcount=count(s:status, '  |  ')

    " Check sync with origin.
    let s:local=substitute(system('git rev-parse '.s:branch), '\n', '', 'g')
    let s:origin=substitute(
                \ system('git rev-parse origin/'.s:branch),
                \ '\n', '', 'g')

    return (s:local!=s:origin?'⛓ ':'') . s:branch
                \ . (s:modcount!=0?'*':'')
endfunction

if has("gui_running")
    " GUI mode.
    " STLUpdate updates some global variables for stl.
    let g:git_status='' " git information
    function STLUpdate(timer)
        " Update git status.
        " Note: Using GitStatus directly in the statusline
        "       will delay text input. For this reason,
        "       we use global variables to cache the result.
        let g:git_status=GitStatus()
    endfunction

    "" " Update git status automatically by timer.
    "" " Note: Isn't a bad way.
    "" augroup updateSTLGlobals
    ""     autocmd!
    ""     autocmd DirChanged * silent :call STLUpdate(0)
    "" augroup END
    "" call timer_start(10000, 'STLUpdate', {'repeat':-1}) " every 10 seconds

    "" " Update git status when manipulating a document.
    "" " Note: Slows down file saving.
    "" augroup updateSTLGlobals
    ""     autocmd!
    ""     autocmd BufWritePost,DirChanged * silent :call STLUpdate(0)
    "" augroup END

    set statusline=%<%f\%{(&modified)?'\*\ ':''}%*%=
    " set statusline+=%{(strlen(&filetype)>0)?'\ Word:\ '.FileWordCount().'\ \｜':''}
    set statusline+=\ Col:\ %2c\ \｜
    set statusline+=\ Row:\ %2l\/%L\ \(%2p%%\)\ \｜
    set statusline+=%{(strlen(&filetype)>0)?'\ '.(&filetype).'\ \｜':''}
    set statusline+=%{(strlen(&filetype)>0)?'\ '.(&encoding).'\ \｜':''}
    " set statusline+=%{(strlen(&filetype)>0)?'\ '.FileReadOnly().'\ \｜':''}
    set statusline+=%{g:git_status!=''?'\ '.g:git_status.'\ \｜':''}
    set statusline+=%{mode()=='n'?'\ ◎\ ':'\ ✎\ '}
else
    " Terminal mode.
    set statusline=%<%f\%{(&modified)?'\*\ ':''}%*%=
    set statusline+=\ Col:\ %c\ \｜
    set statusline+=\ Row:\ %l\/%L\ \(%p%%\)\ \｜
    set statusline+=%{(strlen(&filetype)>0)?'\ '.(&filetype).'\ \｜':''}
    set statusline+=%{(strlen(&filetype)>0)?'\ '.(&encoding).'\ \｜':''}
    set statusline+=%{mode()=='n'?'\ ◎\ ':'\ ✎\ '}
endif

" BACKSPACE
" Influences the working of <BS>, <Del>, CTRL-W and CTRL-U in Insert mode:
"     indent  allow backspacing over autoindent;
"     eol     allow backspacing over line breaks (join lines);
"     start   allow backspacing over the start of insert; CTRL-W and CTRL-U
"             stop once at the start of insert.
set backspace=indent,eol,start

" WORKSPACE SIZE
" Maximum width of text that is being inserted and horizontal line (marker)
" for the 'tw' position. And set the wrap method of words that go beyond
" these boundaries in width.
set colorcolumn=80
set nowrap
" set textwidth=79
" set wrap
" set linebreak
" set dy=lastline
" set sidescroll=5
" set sidescrolloff=5
" set listchars+=precedes:<,extends:>

" INDENT SETTINGS
" Automatic indentation of newline:
"     autoindent   copy indent from current line when starting a new line
"                  (typing <CR> in Insert mode or when using the 'o' or 'O'
"                  command);
"     smartindent  automatically inserts indentation in some cases;
"     cindent      like smartindent, but stricter and more customizable;
"     indentexpr   expression which is evaluated to obtain the proper
"                  indent for a line.
"set indentexpr=''
set indentexpr=''
set autoindent
"set smartindent
"set cindent

" SPECIAL CHAR SETTINGS
" Display wildcards: tabs and spaces at the end.
" Examples: ⦙·, ·, ↪\, →\, ↲, ␣, •, ⟩, ⟨
set list listchars=tab:»·,trail:·

" FILE SETTINGS
" Automatic refresh of the buffer if an open file is changed.
set autoread
au FocusGained * :checktime

" SYSTEM
" The length of time Vim waits after you stop typing before it
" triggers the plugin is governed by the setting updatetime.
" Defaults == 5000.
" Note: The lower the updatetime - the more glitches!
"       For Vim 7 the value must not be less than 1000 (one thousand)!
if has('gui_running')
    set updatetime=128
endif

" SCROLL
" Use Ctrl+Up and Ctrl+Down to scroll a 30% of the screen up or down.
function! ScrollQuarter(move)
    let s:height=winheight(0)
    "if a:move == 'up'
    "    let key='\<C-Y>'
    "else
    "    let key='\<C-E>'
    "endif
    "execute 'normal! ' . float2nr(round(s:height*0.3)) . key
    if a:move == 'up'
        let prep='L'
        let key='gk'
        let post='zb'
    elseif a:move == 'down'
        let prep='H'
        let key='gj'
        let post='zt'
    endif
    execute 'normal! ' . prep . float2nr(round(s:height*0.55)) . key . post
endfunction

imap <C-Up> <Esc>:call ScrollQuarter('up')<CR>
nmap <C-Up> :call ScrollQuarter('up')<CR>
imap <C-Down> <Esc>:call ScrollQuarter('down')<CR>
nmap <C-Down> :call ScrollQuarter('down')<CR>

"" nnoremap <silent> <up> :call ScrollQuarter('up')<CR>
"" nnoremap <silent> <down> :call ScrollQuarter('down')<CR>

" MOUSE
" Left Mouse Click.
" To change for a specific file, for example GoLang filetype:
"     autocmd FileType go nmap <buffer> <C-LeftMouse> :<C-u>call go#def#Jump("tab", 0)<CR>
""" nnoremap <silent> <C-LeftMouse> <LeftMouse>:echom 'Undefined...'<CR>

" Disable default Ctrl+LeftMouse globally to avoid conflicts
nnoremap <silent> <C-LeftMouse> <Nop>

" Allow specific filetypes to define their own Ctrl+LeftMouse behavior
autocmd FileType python,javascript,typescript,html,css,json,vim nnoremap <buffer> <C-LeftMouse> <LeftMouse><Plug>(coc-definition)

" Fallback for other filetypes
nnoremap <silent> <C-LeftMouse> <LeftMouse>:echo 'No definition jump available'<CR>

" http://vimdoc.sourceforge.net/htmldoc/options.html#'mouse'
"set mouse=nicr " no more visual mode from using mouse
set mouse=nvicr
if has("mouse_sgr")
    set ttymouse=sgr
else
    set ttymouse=xterm2
end

"'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"
"'' FILE ASSOCIATION                                                        ''"
"'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"
" Correct syntax highlighting for certain file types.
autocmd BufNewFile,BufRead *.less set filetype=less
autocmd BufNewFile,BufRead *.html set filetype=htmldjango
autocmd BufNewFile,BufRead *.md set filetype=markdown
autocmd BufNewFile,BufRead *.tornado set filetype=html.tornadotmpl
autocmd BufNewFile,BufRead *.py set filetype=python
autocmd BufNewFile,BufRead *.pyx set filetype=cython
autocmd BufNewFile,BufRead *.css set filetype=css
autocmd BufNewFile,BufRead *.scss set filetype=scss
autocmd BufNewFile,BufRead *.po set filetype=po
autocmd BufNewFile,BufRead *.go set filetype=go
autocmd BufNewFile,BufRead *.gohtml set filetype=gotplhtml
autocmd BufNewFile,BufRead *.jinja set filetype=jinja
autocmd BufNewFile,BufRead *.json set filetype=json
autocmd BufNewFile,BufRead *.template set filetype=txt
autocmd BufNewFile,BufRead *.gql set filetype=graphql
autocmd BufNewFile,BufRead *.graphql set filetype=graphql
autocmd BufNewFile,BufRead *.proto set filetype=proto
autocmd BufNewFile,BufRead *.cfg set filetype=haproxy
autocmd BufNewFile,BufRead *.sql set filetype=sql
autocmd BufNewFile,BufRead *.yaml set filetype=yaml
autocmd BufRead,BufNewFile */nginx/*.conf if &ft == '' | setfiletype nginx | endif

" ... for typescript and html/css files it is recommended to set 2 spaces.
" - tabstop answers the question: how many columns of whitespace
"   is a \t char worth? Think of a set of vertical lines running down
"   the length of your paper.
" - shiftwidth answers the question: how many columns of whitespace
"   a “level of indentation” is worth?
" - softtabstop answers the question: how many columns of whitespace is
"   a tab keypress or a backspace keypress worth?
" - expandtab means that you never wanna see a \t again in your
"   file — rather, tabs keypresses will be expanded into spaces.
autocmd FileType json setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2
autocmd FileType html setlocal expandtab tabstop=4 softtabstop=4 shiftwidth=4
autocmd FileType markdown setlocal expandtab tabstop=4 softtabstop=4 shiftwidth=4
autocmd FileType gotplhtml setlocal shiftwidth=4 tabstop=4
autocmd FileType html.tornadotmpl setlocal shiftwidth=4 tabstop=4
autocmd FileType htmldjango setlocal shiftwidth=4 tabstop=4
autocmd FileType jinja setlocal shiftwidth=4 tabstop=4
autocmd FileType scss setlocal expandtab tabstop=4 softtabstop=4 shiftwidth=4
autocmd FileType css setlocal shiftwidth=4 tabstop=4
autocmd FileType typescript setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2
autocmd FileType javascript setlocal shiftwidth=4 tabstop=4
autocmd FileType python setlocal expandtab shiftwidth=4 softtabstop=4
autocmd FileType sh setlocal shiftwidth=4 tabstop=4
autocmd FileType make setlocal noexpandtab
autocmd FileType go setlocal noexpandtab
autocmd FileType vue setlocal shiftwidth=4 tabstop=4
autocmd FileType graphql setlocal expandtab shiftwidth=4 softtabstop=4
autocmd FileType proto setlocal expandtab shiftwidth=4 softtabstop=4
autocmd FileType haproxy setlocal expandtab shiftwidth=4 softtabstop=4
autocmd FileType nginx setlocal expandtab shiftwidth=4 softtabstop=4
autocmd FileType sql setlocal shiftwidth=4 tabstop=4
autocmd FileType yaml setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2


" TypeScript: see TYPESCRIPT PLUGIN section
" autocmd BufNewFile,BufRead *.ts set filetype=typescript

" GoLang: see VIM-GO PLUGIN section
" autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4

" When updated the buffer need update syntax highlighting too.
" This is important when searching in large files.
function SyncFromStart() abort
    set lazyredraw " https://vimhelp.org/options.txt.html#%27lazyredraw%27
    silent execute 'syntax sync fromstart'
    " execute 'redraw'
    set nolazyredraw
endfunction
autocmd BufEnter,BufWritePost * :call SyncFromStart()


"'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"
"'' GLOBAL KEY MAPPING                                                      ''"
"'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"
" UNDO/REDO
" USAGE: Ctrl+Alt+u and Ctrl+Alt+r
nmap <C-u> :echo 'For `Undo` and `Redo` use the `Ctrl+z` and `Ctrl+r` respectively!'<CR>
nmap <C-r> :echo 'For `Undo` and `Redo` use the `Ctrl+z` and `Ctrl+r` respectively!'<CR>

nmap u :undo<CR>
imap <C-z> <Esc>:undo<CR>
nmap <C-z> :undo<CR>
nnoremap <C-z> <Esc>:undo<CR>
imap <C-r> <Esc>:redo<CR>
nmap <C-r> :redo<CR>
nnoremap <C-r> <Esc>:redo<CR>


" COPY/PASTE
" USAGE: Ctrl+Insert and Shift+Insert or Ctrl+c and Ctrl+v
vmap <C-Insert> "+y
vmap <S-Insert> "+p
vmap <C-c> "+y
imap <C-c> <ESC> "+y
vmap <C-v> "+p
imap <C-v> <ESC> "+p

" SAVE CURRENT FILE
" USAGE: F2
imap <F2> <Esc>:w!<CR>
nmap <F2> :w!<CR>

" OPEN ENCODING MENU
" USAGE: F8
set wildmenu
set wcm=<Tab>
menu Encoding.utf-8 :e ++enc=utf8 <CR>
menu Encoding.koi8-r :e ++enc=koi8-r ++ff=unix<CR>
menu Encoding.windows-1251 :e ++enc=cp1251 ++ff=dos<CR>
menu Encoding.cp866 :e ++enc=cp866 ++ff=dos<CR>
menu Encoding.koi8-u :e ++enc=koi8-u ++ff=unix<CR>
map <F8> :emenu Encoding.<TAB>


"'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"
"'' EDIT MODE                                                               ''"
"'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"
" SEARCH
" Ignore upper/lower cases.
set ignorecase
set smartcase

""" Highlight found matches and remove backlight when button `Esc` is pressed.
set hlsearch
nnoremap <Esc> :noh<return><Esc>

" VISUAL SELECT ALL
" USAGE: Ctrl+Alt+a
map <C-A-a> <Esc>ggVG<CR>


"'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"
"'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"
"''                                                                         ''"
"''                           PLUGIN SETTINGS                               ''"
"''                                                                         ''"
"'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"
"'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"

"'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"
"'' SQL                                                                     ''"
"'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"
let g:omni_sql_no_default_maps=1
let g:omni_sql_default_compl_type='syntax'


"'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"
"'' TABS                                                                    ''"
"'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"
" Styling of the tabs.
" USAGE:
"     F5     - open previous tab;
"     F6     - open next tab;
"     F7     - make new tab;
"     Ctrl+j - move tab left;
"     Ctrl+k - move tab right;
"     Ctrl+h - move tab to first position;
"     Ctrl+l - move tab to last position;
"     Ctrl+z - open first tab.
" DOC:
"     https://github.com/valsorym/vim-tabs

" BUFFER/TAB SETTINGS
" Show panel of tabs and limit the number of open tabs.
set tabpagemax=55 " for use -p flag: vim -p file_1 file_2 ... file_N
set showtabline=2

" PREVIOUS TAB
" USAGE: F5 or Ctrl+ArrowLeft
imap <F5> <Esc>:tabprev<CR>
nmap <F5> :tabprev<CR>
" map <C-Left> :tabprev<CR>

" NEXT TAB
" USAGE: F6 or Ctrl+ArrowRight
imap <F6> <Esc>:tabnext<CR>
nmap <F6> :tabnext<CR>
" map <C-Right> :tabnext<CR>

" CREATE NEW TAB
" USAGE: F7 or Ctrl+n
imap <F7> <Esc>:tabnew<CR>
nmap <F7> :tabnew<CR>
imap <C-n> <Esc>:tabnew<CR>
nmap <C-n> :tabnew<CR>

" MOVE TAB TO LEFT
" USAGE: Ctrl+Shift+j
imap <C-S-j> <Esc>:call MoveTabLeft()<CR>
nmap <C-S-j> :call MoveTabLeft()<CR>

" MOVE TAB TO RIGHT
" USAGE: Ctrl+Shift+k
imap <C-S-k> <Esc>:call MoveTabRight()<CR>
nmap <C-S-k> :call MoveTabRight()<CR>

" MOVE TAB TO FIRST POSITION
" USAGE: Ctrl+h
imap <C-S-h> <Esc>:call MoveTabFirst()<CR>
nmap <C-S-h> :call MoveTabFirst()<CR>

" MOVE TAB TO LAST POSITION
" USAGE: Ctrl+l
imap <C-S-l> <Esc>:call MoveTabLast()<CR>
nmap <C-S-l> :call MoveTabLast()<CR>

" TAB STYLE
" 0. Short tabs - only filename.
" 1. Show parent folder + filename.
" 2. Show only first and last symbol from parent folder + filename.
" 3. Show only first symbol from parent folder + filename.
" 4. Show only three first symbols from parent folder + filename.
" Show only three first symbols from parent folder + filename.
set tabline=%!TabName(4)

""" Automatically move the tab to the last position.
if has('autocmd')
    " If open a lot of tabs and when the tab is editing - move tab to last
    " position.
    autocmd InsertEnter * call AutoMoveTabLast()

    " If open new tab - move it to the last position.
    autocmd BufNew * call NewTabMoveLast()

    " Autoclose duplicate tabs.
    " + Add `CloseDuplicateTabs` - duplicate tabs closing command.
    " * If used NewTabMoveLast method - use CloseDuplicateTabs(1).
    autocmd BufEnter * call CloseDuplicateTabs(1)
    command CloseDuplicateTabs :call CloseDuplicateTabs(1)
endif " autocmd


"'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"
"'' CLEAR DEBRIS                                                            ''"
"'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"
" Remove trailing blanks.
" USAGE: <C-A-x>, a
" DOC:
"     https://github.com/valsorym/vim-clear
"
" Key mapping.
command -bar -nargs=? ShowSpaces call ShowSpaces(<args>)
command -bar -nargs=0 -range=% TrimSpaces <line1>,<line2>call TrimSpaces()
imap <C-A-x> <Esc>:TrimSpaces<CR>
nmap <C-A-x> :TrimSpaces<CR>
"nmap <A-x> :TrimSpaces<CR>


"'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"
"'' NERDTREE / NERDTREE-TABS                                                ''"
"'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"
" The NERD tree allows you to explore your filesystem and to open files and
" directories. It presents the filesystem to you in the form of a tree which
" you manipulate with the keyboard and/or mouse. It also allows you to
" perform simple filesystem operations.
" USAGE: F9
" DOC:
"     http://www.vim.org/scripts/script.php?script_id=1658
"     https://github.com/scrooloose/nerdtree
"     https://github.com/jistr/vim-nerdtree-tabs

" Position and size
let g:NERDTreeWinPos = 'left'
let g:NERDTreeWinSize = 36

" Critical settings for NERDTree as sidebar with tabs support
let g:NERDTreeQuitOnOpen = 0           " Don't close NERDTree when opening a file
let g:NERDTreeAutoDeleteBuffer = 1     " Auto delete buffer when file is deleted via NERDTree
let g:NERDTreeMinimalUI = 1            " Simplified NERDTree interface
let g:NERDTreeShowHidden = 1           " Show hidden files
let g:NERDTreeHighlightCursorline = 1  " Enable cursor line highlighting

" Keep NERDTree open across all tabs
let g:nerdtree_tabs_open_on_console_startup = 1
let g:nerdtree_tabs_open_on_gui_startup = 1
let g:nerdtree_tabs_autoclose = 0      " Don't close NERDTree when closing the last tab
let g:nerdtree_tabs_synchronize_view = 1
let g:nerdtree_tabs_focus_on_files = 1

" Do not change directory automatically
set noautochdir
let g:NERDTreeChDirMode = 2
let g:NERDTreeMapOpenSplit = 's'
let g:NERDTreeMapOpenVSplit = 'v'

" Ignore files
let g:NERDTreeIgnore = [
    \ '\.pyc$',
    \ '\.swo$',
    \ '\.swp$',
    \ '\.core$',
    \ '\.o$',
    \ '^_del\.',
    \ '^\.del\.'
\]

"" Ensure cursor is visible in NERDTree
augroup NERDTreeCursor
    autocmd!
    autocmd FileType nerdtree setlocal cursorline
    autocmd FileType nerdtree hi CursorLine cterm=bold ctermbg=238 ctermfg=255 gui=bold guibg=#444444 guifg=#ffffff
    autocmd FileType nerdtree hi CursorLineNr cterm=bold ctermbg=238 ctermfg=226 gui=bold guibg=#444444 guifg=#ffff00
    autocmd FileType nerdtree hi Cursor cterm=NONE ctermbg=NONE gui=NONE guibg=NONE
augroup END

" Disable sign column in NERDTree
augroup NERDTreeSignColumn
    autocmd!
    autocmd FileType nerdtree setlocal signcolumn=no
augroup END

" Configure NERDTree to open files in tabs
let g:NERDTreeCustomOpenArgs = {
    \ 'file': {
        \ 'reuse': 'all',
        \ 'where': 't',
        \ 'keepopen': 1,
        \ 'stay': 0
    \ },
    \ 'dir': {}
\}

" Key mappings
let g:NERDTreeMapOpenInTab = '<CR>'    " Open file in new tab with Enter
let g:NERDTreeMapOpenExpl = ''         " Disable default 'e' mapping
let g:NERDTreeMapOpenSplit = 's'       " Open in split
let g:NERDTreeMapOpenVSplit = 'v'      " Open in vertical split

" Add Bookmark
imap <C-b> <Esc>:Bookmark<Space>
nmap <C-b> :Bookmark<Space>

" Check if NERDTree is open
function! NERDTreeIsOpen()
    return exists('t:NERDTreeBufName') && (bufwinnr(t:NERDTreeBufName) != -1)
endfunction

" Get NERDTree window number
function! GetNERDTreeWinNr()
    if exists('t:NERDTreeBufName')
        return bufwinnr(t:NERDTreeBufName)
    endif
    return -1
endfunction

" Check if current window is NERDTree
function! IsNERDTreeWindow()
    return GetNERDTreeWinNr() == winnr()
endfunction

" NERDTreeSync synchronizes the selected file with NERDTree
function! NERDTreeSync()
    if IsNERDTreeWindow()
        return
    endif

    let s:file_path = expand('%:p')
    if NERDTreeIsOpen() && !IsTechBuffer(s:file_path, 0)
        try
            NERDTreeTabsFind
            wincmd p
        catch
        endtry
    endif

    " Update titlestring
    if !exists('g:titlestring')
        let g:titlestring = '%t'
    endif
    if IsTechBuffer(s:file_path, 0)
        let s:file_path = ""
        let s:buflist = tabpagebuflist()
        for i in s:buflist
            let s:buf_file_path = fnamemodify(bufname(i), ':p')
            if bufexists(i) && !IsTechBuffer(s:buf_file_path, 0) && bufwinnr(i) >= 0
                let s:file_path = s:buf_file_path
                break
            endif
        endfor
    endif

    if strlen(s:file_path) > 0
        try
            let s:project_path = g:NERDTree.ForCurrentTab().getRoot().path.str()
            let s:project_name = fnamemodify(s:project_path, ':t')
            let s:file_name = fnamemodify(s:file_path, ':t')
            let s:file_path = substitute(s:file_path, s:file_name, '', '')
            let s:file_path_len = strlen(s:file_path)
            let s:file_path_max_len = 16
            let s:title = toupper(s:project_name) . '\ →\ ' . s:file_name
            if strlen(s:project_name) == 0
                let s:title = s:file_name
            elseif strlen(s:file_name) == 0
                let s:title = toupper(s:project_name)
            endif
            if s:file_path_len > 0 && strpart(s:file_path, 0, 1) != '/'
                if s:file_path_len > s:file_path_max_len + 1
                    let s:path = '...' . strpart(s:file_path, s:file_path_len - s:file_path_max_len, s:file_path_max_len - 1)
                else
                    let s:path = strpart(s:file_path, 0, s:file_path_len - 1)
                endif
                let s:title = toupper(s:project_name) . '\ →\ ' . s:path . '\ →\ ' . s:file_name
            endif
            let &titlestring = s:title
            let &titlelen = 79
        catch
            let &titlestring = g:titlestring
        endtry
    else
        let &titlestring = g:titlestring
    endif
endfunction

" Auto sync
augroup execNERDTreeSync
    autocmd!
    autocmd VimEnter,BufCreate,BufWipeout,BufEnter,BufLeave,TabEnter * call NERDTreeSync()
augroup END

" Toggle NERDTree
function! NERDTreeSmartToggle()
    if NERDTreeIsOpen()
        NERDTreeTabsClose
    else
        NERDTreeTabsToggle
    endif
endfunction

nmap <silent> <F9> :call NERDTreeSmartToggle()<CR>
imap <silent> <F9> <Esc>:call NERDTreeSmartToggle()<CR>

" Function to close only the current buffer, not the entire window
function! CloseCurrentBufferOnly()
    " Store the current buffer and window
    let l:current_buf = bufnr('%')
    let l:current_win = winnr()

    " If this is NERDTree window, switch to another window
    if IsNERDTreeWindow()
        wincmd p
        return
    endif

    " Check if buffer is modified
    if &modified
        echo "Buffer is modified. Save first or use :bdelete! to force close."
        return
    endif

    " Try to find another buffer to switch to
    let l:found_alt = 0
    let l:alt_buffers = []

    " Collect all non-technical buffers
    for buf in range(1, bufnr('$'))
        if buflisted(buf) && buf != l:current_buf && bufexists(buf)
            if !IsTechBuffer(bufname(buf), 0)
                call add(l:alt_buffers, buf)
            endif
        endif
    endfor

    " If we have alternative buffers, switch to the first one
    if len(l:alt_buffers) > 0
        execute 'buffer ' . l:alt_buffers[0]
        let l:found_alt = 1
    endif

    " Delete the original buffer
    if bufexists(l:current_buf)
        execute 'bdelete ' . l:current_buf
    endif

    " If no other buffer was found, create a new one
    if !l:found_alt
        enew
        setlocal nomodified
    endif

    " Make sure NERDTree remains visible if it was open
    if NERDTreeIsOpen() && winnr('$') == 1
        NERDTreeFocus
        wincmd p
    endif
    redraw!
endfunction

" Smart tab closing that keeps NERDTree open
function! SmartTabClose()
    " If we're in NERDTree window
    if IsNERDTreeWindow()
        " Try to move to a non-NERDTree window
        wincmd p

        " If we couldn't move (only NERDTree is open)
        if IsNERDTreeWindow()
            " If multiple tabs exist, close current tab
            if tabpagenr('$') > 1
                tabclose
            else
                " Otherwise quit all
                quitall
            endif
        endif
        return
    endif

    " Count non-NERDTree windows
    let l:normal_windows = 0
    let l:window_count = winnr('$')

    for i in range(1, l:window_count)
        if getbufvar(winbufnr(i), '&filetype') != 'nerdtree'
            let l:normal_windows += 1
        endif
    endfor

    " If this is the only non-NERDTree window in the current tab
    if l:normal_windows <= 1
        " If there are multiple tabs
        if tabpagenr('$') > 1
            tabclose
        else
            " If multiple buffers exist, try to switch to another
            call CloseCurrentBufferOnly()
        endif
    else
        " Close only current window
        quit
    endif
endfunction

" Better ZZ behavior with NERDTree - save and close buffer
function! NERDTreeSmartZZ()
    " If we're in NERDTree, switch to previous window
    if IsNERDTreeWindow()
        wincmd p
        return
    endif

    " Save if modified
    if &modified
        write
    endif

    " Close current buffer only
    call CloseCurrentBufferOnly()
endfunction

" Overwrite standard commands
" Map q to SmartTabClose
nnoremap <silent> q :call CloseCurrentBufferOnly()<CR>
nnoremap <silent> <Leader>q :call CloseCurrentBufferOnly()<CR>

" Map ZZ to NERDTreeSmartZZ
nnoremap <silent> ZZ :call NERDTreeSmartZZ()<CR>

" Replace standard q! with forced buffer close
command! -nargs=0 -bang Q call CloseCurrentBufferOnly()
command! -nargs=0 -bang QF execute 'bdelete<bang>'

cnoreabbrev q Q
cnoreabbrev q! Q!

" Prevent NERDTree from becoming the only window
augroup NERDTreePrevent
    autocmd!
    autocmd BufEnter * if (winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree()) | quitall | endif
augroup END

" Mouse handling in NERDTree
augroup NERDTreeMouseOpen
    autocmd!
    autocmd FileType nerdtree nnoremap <buffer> <LeftMouse> <LeftMouse>:call nerdtree#ui_glue#invokeKeyMap('o')<CR>
    autocmd FileType nerdtree nnoremap <buffer> <2-LeftMouse> <2-LeftMouse>:call nerdtree#ui_glue#invokeKeyMap('t')<CR>
augroup END




"'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"
"'' BUFEXPLORER                                                             ''"
"'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"
" Plugin for easily browsing for buffers/tabs.
" USAGE: Ctrl+t
" DOC:
"     https://github.com/andrewvc/vim-settings/blob/master/doc/bufexplorer.txt

" Don't show default and detail help.
let g:bufExplorerDefaultHelp=0
let g:bufExplorerDetailedHelp=0

" Don't show dirs, show relative paths and split filename with path.
let g:bufExplorerShowDirectories=0
let g:bufExplorerShowRelativePath=1
let g:bufExplorerSplitOutPathName=0

" Split new window above current
let g:bufExplorerSplitBelow=0

" Sort by full file path name.
let g:bufExplorerSortBy='fullpath'

" Open buffer/tab list.
" OpenBufExplorer opens cell BufExplorerHorizontalSplit.
function! OpenBufExplorer()
    " Use in editable buffers only.
    if &modifiable && strlen(expand('%')) > 0 && !&diff
        try
            BufExplorerHorizontalSplit
        catch
        endtry
    endif
endfunction

imap <C-t> <Esc> :call OpenBufExplorer()<CR>
nmap <C-t> :call OpenBufExplorer()<CR>


"'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"
"'' DEOPLETE                                                                ''"
"'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"
" It provides an extensible and asynchronous completion framework for Vim8.
" Next generation completion framework after neocomplcache.
" DOC:
"     https://github.com/Shougo/deoplete.nvim
if has('gui_running')
    let g:deoplete#enable_at_startup=1
endif


"'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"
"'' COLORIZER                                                               ''"
"'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"
" Color highlight toggle.
" Highlights the specific color code in CSS, for example: #efefef, red etc.
" USAGE: Alt+i
" DOC:
"     https://github.com/chrisbra/colorizer

" Key mapping.
nmap <A-i> :ColorToggle<CR>


"'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"
"'' MULTIPLE CURSORS                                                        ''"
"'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"
" USAGE:
"     Shift-f - start/the allocation of the next word under the cursor, and:
"         Shift-b - the allocation of the previous word under the cursor;
"         Shift-x - ignore the current word and move on to the next;
"     After selecting all the words, you can start editing:
"         c - remove word and go into edit mode;
"         I - set the cursor in the beginning of the word;
"         A - set the cursor at the end of the word.
" DOC:
"     https://github.com/terryma/vim-multiple-cursors

" Disable default mapping.
let g:multi_cursor_use_default_mapping=0

" Key mapping.
let g:multi_cursor_next_key='<S-f>'
let g:multi_cursor_prev_key='<S-p>'
let g:multi_cursor_skip_key='<S-s>'
let g:multi_cursor_quit_key='<Esc>'

" Fix bug with deoplete: https://github.com/Shougo/deoplete.nvim/issues/265
function g:Multiple_cursors_before()
    if has('gui_running')
        call deoplete#custom#buffer_option('auto_complete', v:false)
    endif
endfunction

function g:Multiple_cursors_after()
    if has('gui_running')
        call deoplete#custom#buffer_option('auto_complete', v:true)
    endif
endfunction


"'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"
"'' JSON                                                                    ''"
"'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"
" JSON for Vim.
let g:vim_json_syntax_conceal=0 " 0 - JSON highlighting in raw mode.


"'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"
"'' TYPESCRIPT                                                              ''"
"'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"
let g:typescript_compiler_binary='tsc'
let g:typescript_compiler_options=''
autocmd BufNewFile,BufRead *.ts set filetype=typescript
" autocmd FileType typescript :set makeprg=tsc
autocmd FileType typescript setlocal formatprg=prettier\ --parser\ typescript
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow


"'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"
"'' PYTHON                                                                  ''"
"'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"
" Enable code definition navigation for Python files
" Allows jumping to function/class definitions with Ctrl+LeftMouse

augroup pythonCodeNavigation
    autocmd!
    " Map Ctrl+LeftMouse to jump to definition in Python files
    autocmd FileType python nnoremap <buffer> <C-LeftMouse> <LeftMouse>:call PythonJumpToDefinition()<CR>

    " Map Ctrl+Alt+j as keyboard alternative for jumping to definition
    autocmd FileType python nmap <buffer> <C-A-j> :call PythonJumpToDefinition()<CR>
augroup END

" Function to find and jump to Python definition
function! PythonJumpToDefinition()
    " Get the word under cursor
    let l:word = expand("<cword>")
    if empty(l:word)
        echo "No word under cursor"
        return
    endif

    " Save current position and view
    let l:save_pos = getpos(".")
    let l:save_view = winsaveview()

    " Try to find definition patterns for the word
    " Create patterns for different Python definition types
    let l:patterns = [
        \ '^\s*def\s\+' . l:word . '\s*(',
        \ '^\s*class\s\+' . l:word . '\b',
        \ '^\s*async\s\+def\s\+' . l:word . '\s*(',
        \ '^\s*def\s\+' . l:word . '\s*\[',
        \ '^\s*self\.' . l:word . '\s*=',
        \ '^\s*' . l:word . '\s*=s*\(function\|lambda\|def\)',
        \ '^\s*' . l:word . '\s*=',
        \ '^\s*\(\w\+\.\)*' . l:word . '\s*=',
        \ '^\s*' . l:word . '\s*:\s*',
        \ '^\s*@property\s*\n\s*def\s\+' . l:word
    \ ]

    " First try to search from beginning of the file
    normal! gg
    for pattern in l:patterns
        if search(pattern, 'W')
            " Definition found!
            normal! zz
            echo "Found definition for '" . l:word . "'"
            return
        endif
        " Reset cursor to beginning for next pattern
        normal! gg
    endfor

    " Special check for class methods
    let l:method_patterns = [
        \ '^\s*def\s\+' . l:word . '\s*(self',
        \ '^\s*async\s\+def\s\+' . l:word . '\s*(self'
    \ ]

    normal! gg
    for pattern in l:method_patterns
        if search(pattern, 'W')
            " Class method found!
            normal! zz
            echo "Found method definition for '" . l:word . "'"
            return
        endif
        " Reset cursor to beginning for next pattern
        normal! gg
    endfor

    " If still not found, try a more aggressive search
    " Find any line that might represent a definition
    normal! gg
    let l:aggressive_pattern = '\<' . l:word . '\>.*[=(:)]'
    if search(l:aggressive_pattern, 'W')
        let l:line = getline('.')
        " Check if this looks like a definition
        if l:line =~ '^\s*\(def\|class\|async\|@\|' . l:word . '\)'
            normal! zz
            echo "Found possible definition for '" . l:word . "'"
            return
        endif
    endif

    " Last resort: try to find any appearance of the word in a method or property
    normal! gg
    let l:hard_to_find_patterns = [
        \ '\<self\.' . l:word . '\>\s*[=(]',
        \ '\<' . l:word . '\>\s*=\s*'
    \ ]

    for pattern in l:hard_to_find_patterns
        if search(pattern, 'W')
            normal! zz
            echo "Found possible assignment for '" . l:word . "'"
            return
        endif
        normal! gg
    endfor

    " If still not found, restore position and show message
    call setpos('.', l:save_pos)
    call winrestview(l:save_view)
    echo "Definition for '" . l:word . "' not found in current file"
endfunction


"'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
"'' COC (CONQUER OF COMPLETION)                                              ''
"'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
" Configuration for CoC language server client
" Provides IDE-like features for multiple languages

" Install CoC extensions automatically
let g:coc_global_extensions = [
    \ 'coc-pyright',
    \ 'coc-json',
    \ 'coc-yaml',
    \ 'coc-vimlsp',
    \ 'coc-html',
    \ 'coc-css',
    \ 'coc-tsserver',
    \ 'coc-snippets',
    \ 'coc-pairs'
    \ ]

" Set shorter updatetime for faster completion refresh
set updatetime=300

" Avoid passing messages to ins-completion-menu
set shortmess+=c

" Always show sign column for error indicators
set signcolumn=yes

" Disable type hints being inserted directly into code
" Disable displaying type hints directly in the code
call coc#config('suggest.snippetsSupport', v:false)
call coc#config('suggest.enablePreview', v:false)
call coc#config('suggest.noselect', v:true)
call coc#config('suggest.keepCompleteopt', v:true)
call coc#config('inlayHint.enable', v:false)

" Disable inlay hints for Python
" Disable embedded hints for Python
call coc#config('pyright.disableInlayHints', v:true)
call coc#config('python.inlayHints.enable', v:false)

" Tab: select next item or trigger completion or insert tab
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
" Shift-Tab: select previous item in completion menu
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Enter: confirm completion item if visible, else insert newline
" Modified to prevent automatic insertion of type hints
" Modified to prevent automatic insertion of type hints
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Ctrl+Space to manually trigger completion
inoremap <silent><expr> <c-space> coc#refresh()

" Navigate diagnostics: previous and next
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Go to definitions and references
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Ctrl+LeftMouse jumps to definition in specified filetypes
autocmd FileType python,javascript,typescript,html,css,json,vim nnoremap <buffer> <C-LeftMouse> <LeftMouse><Plug>(coc-definition)

" Ctrl+Alt+j as keyboard alternative to jump to definition
autocmd FileType python,javascript,typescript,html,css,json,vim nmap <buffer> <C-A-j> <Plug>(coc-definition)

" Show documentation with K key
nnoremap <silent> K :call ShowDocumentation()<CR>
function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight symbol and references on cursor hold
autocmd CursorHold * silent call CocActionAsync('highlight')

" [!] Conflict. Use F2 for svaing.
" " Rename symbol with F2
" nmap <F2> <Plug>(coc-rename)
"
" hi! CocFloating ctermbg=NONE ctermfg=White guibg=#1f1f1f guifg=White
" hi! Pmenu ctermbg=236 ctermfg=White guibg=#333333 guifg=White
" hi! PmenuSel ctermbg=240 ctermfg=Black guibg=#555555 guifg=#ffffff
" hi! NormalFloat guibg=#1f1f1f guifg=White


" Format selected code or buffer
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Apply code actions to selected region
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Auto fix current line problems
nmap <leader>qf  <Plug>(coc-fix-current)

" Add :Format command for formatting buffer
command! -nargs=0 Format :call CocActionAsync('format')

" Add :Fold command for folding buffer (optional)
command! -nargs=? Fold :call CocAction('fold', <f-args>)

" Python-specific settings
" Specific settings for Python
autocmd FileType python call coc#config('python', {
      \ 'analysis': {
      \   'typeCheckingMode': 'off',
      \   'inlayHints': {
      \     'enable': v:false,
      \     'variableTypes': v:false,
      \     'functionReturnTypes': v:false,
      \     'parameterTypes': v:false
      \   }
      \ }
      \})

" Create a command to toggle inlay hints if you ever need them
" Create a command for quick enabling/disabling of type hints
command! -nargs=0 ToggleInlayHints call ToggleInlayHints()
function! ToggleInlayHints()
  let current = CocAction('getConfig', 'inlayHint.enable')
  call coc#config('inlayHint.enable', !current)
  call coc#config('pyright.disableInlayHints', current)
  echo "Inlay hints " . (!current ? "enabled" : "disabled")
endfunction

"'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"
"'' VIM-GO                                                                  ''"
"'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"
" GoLang development plugin for Vim.
" USAGE: (only for .go files)
"     Ctrl+Alt+f - run gofmt;
"     Ctrl+Alt+l - run linters;
"     Ctrl+Alt+j - jump to definition (in new tab);
"     Ctrl+Alt+d - open go-doc;
"     Ctrl+Alt+i - show info about object.
" DOC:
"     https://github.com/fatih/vim-go
" Definition.
let g:go_version_warning=0

" Fmt.
""" " The gofump fmt mode: https://github.com/mvdan/gofumpt#vim-go
""" " Note: Poorly organized import list.
""" let g:go_fmt_command='gopls'
""" let g:go_gopls_gofumpt=1
let g:go_fmt_autosave=1 " automatic formatting when saving
let g:go_fmt_fail_silently=1

""" let g:go_fmt_command='goimports' " classical goimports
let g:go_fmt_command='golines' " controlling imports and formatting line length
let g:go_fmt_options={
    \ 'golines': '-m 79',
    \ }

" Info mode.
" Automatic display of information about the object.
let g:go_info_mode='guru'
let g:go_auto_type_info=0 " set 1 to activate auto detect,
                          " but 1 doesn't work well with NERDTreeSync

" Go doc.
let g:go_doc_keywordprg_enabled=1

" Highlight.
let g:go_highlight_types=1
let g:go_highlight_fields=1
let g:go_highlight_functions=1
let g:go_highlight_extra_types=1
let g:go_highlight_generate_tags=1
let g:go_highlight_function_calls=1

" Activate linter.
let g:go_metalinter_autosave = 0 " set 1 to activate autosave
let g:go_metalinter_autosave_enabled = ['vet', 'golint', 'errcheck', 'test', 'testify']

let g:go_metalinter_enabled = ['vet', 'golint', 'errcheck', 'test', 'testify']
let g:go_metalinter_deadline = '3s'

" Stop default mapping.
let g:go_def_mapping_enabled=0

augroup remappingGoLang
    autocmd!
    " Customization .go files: show by default 4 spaces for a tab.
    autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4

    " Key mapping.
    " Run fmt: Ctrl+Alt+f
    autocmd FileType go nmap <buffer> <C-A-f> <Esc>:GoFmt<CR>

    " Run linter: Ctrl+Alt+l
    autocmd FileType go nmap <buffer> <C-A-l> <Esc>:GoMetaLinter<CR>

    " Run go-doc: Ctrl+Alt+d
    autocmd FileType go nmap <buffer> <C-A-d> <Esc>:GoDoc<CR>

    " Run info: Ctrl+Alt+i
    autocmd FileType go nmap <buffer> <C-A-i> <Esc>:GoInfo<CR>

    " Jump to definition: Ctrl+Alt+j.
    " Use go-def-tab to open new tab with definition.
    """ " To stop for Ctrl+ Mouse Left Click
    """ let g:go_def_mapping_enabled=0
    autocmd FileType go nmap <buffer> <C-LeftMouse> <Plug>(go-def-tab)
    autocmd FileType go nmap <buffer> <C-A-j> <Plug>(go-def-tab)
augroup END


"'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"
"'' TAGBAR                                                                  ''"
"'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"
" USAGE:
"     F10 - toggle tagbar
" DOC:
"     https://github.com/preservim/tagbar
"
"     GoLang: https://github.com/jstemmer/gotags
" Smart toggle tagbar.
function ToggleTagbar()
    let s:initial_buf=1

    " Don't toggle tagbar if cursor is in tagbar or nerdtree buffers.
    if IsTechBuffer(expand('%'), 1)
        echomsg 'You can`t open TagBar inside the technical buffers!'
    else
        TagbarToggle
    endif

    " Go back to initial buffer.
    " Set g:tagbar_autofocus=0
    while !exists('s:initial_buf')
        wincmd w
    endwhile
    unlet s:initial_buf
endfunction

nmap <silent> <F10> :call ToggleTagbar()<CR>
imap <F10> <Esc>:call ToggleTagbar()<CR>

let g:tagbar_autofocus=1 " 0 - disable autofocus force
let g:tagbar_width=36
let g:tagbar_left=0
let g:tagbar_compact=0
let g:tagbar_sort=1      " tagbar shows tags in order of they created in file
let g:tagbar_foldlevel=1 " 0 - close tagbar folds by default

" https://github.com/preservim/tagbar/wiki
let g:tagbar_type_go={
	\ 'ctagstype' : 'go',
	\ 'kinds'     : [
		\ 'p:package',
		\ 'i:imports:1',
		\ 'c:constants',
		\ 'v:variables',
		\ 't:types',
		\ 'n:interfaces',
		\ 'w:fields',
		\ 'e:embedded',
		\ 'm:methods',
		\ 'r:constructor',
		\ 'f:functions'
	\ ],
	\ 'sro' : '.',
	\ 'kind2scope' : {
		\ 't' : 'ctype',
		\ 'n' : 'ntype'
	\ },
	\ 'scope2kind' : {
		\ 'ctype' : 't',
		\ 'ntype' : 'n'
	\ },
	\ 'ctagsbin'  : 'gotags',
	\ 'ctagsargs' : '-sort -silent'
\ }

let g:tagbar_type_typescript = {
  \ 'ctagsbin' : 'tstags',
  \ 'ctagsargs' : '-f-',
  \ 'kinds': [
    \ 'e:enums:0:1',
    \ 'f:function:0:1',
    \ 't:typealias:0:1',
    \ 'M:Module:0:1',
    \ 'I:import:0:1',
    \ 'i:interface:0:1',
    \ 'C:class:0:1',
    \ 'm:method:0:1',
    \ 'p:property:0:1',
    \ 'v:variable:0:1',
    \ 'c:const:0:1',
  \ ],
  \ 'sort' : 0
\ }


"'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"
"'' RESWAP                                                                  ''"
"'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"
" Reswap (reconnect the swap file) - it helps when working with files through
" SSHFS, after crash.
" USAGE:
"       Shift+Q
function ReSwap()
    execute 'set noswapfile'
    execute 'set swapfile'
    execute ':echo "The swap file was changed!"'
endfunction

nmap <A-q> :call ReSwap()<CR>


"'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"
"'' MATCHUP                                                                 ''"
"'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"
" USAGE:
"       %, [%, ]%, g% and z%
"       Ctrl + Shift
" DOC:
"       https://github.com/andymass/vim-matchup
" Search for a closing tag, parenthesis, or word under the cursor.
let g:loaded_matchit = 1
let g:matchup_matchparen_offscreen = {'method': 'popup'} " 'status', 'status_manual', 'scrolloff'

" The number of lines to search in either direction while highlighting matches.
let g:matchup_matchparen_stopline = 512

" Highlighting timeouts.
let g:matchup_matchparen_timeout = 256
let g:matchup_matchparen_insert_timeout = 64

nnoremap <C-S-?> :<C-u>MatchupWhereAmI?<cr>
augroup changeMatchupHighlight
    autocmd!
    autocmd ColorScheme * hi MatchParen    cterm=bold gui=bold
    autocmd ColorScheme * hi MatchWord     cterm=bold gui=bold
    autocmd ColorScheme * hi MatchParenCur cterm=bold gui=bold
    autocmd ColorScheme * hi MatchWordCur  cterm=bold gui=bold
augroup END


"'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"
"'' MOVE LINES/BLOCKS                                                       ''"
"'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"
" USAGE:
"     Ctrl-k - move current line/selections up;
"     Ctrl-j - move current line/selections down.
" DOC:
"     https://github.com/matze/vim-move

" Key mapping.
let g:move_key_modifier='C'

" Do not change indentation of the moved block.
let g:move_auto_indent=0


" "'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"
" "'' SCROLLBAR                                                               ''"
" "'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"
" " DOC:
" "     https://github.com/obcat/vim-sclow
"
" " Block scrollbar for specific file types and buffers
" let g:sclow_block_filetypes=['netrw', 'nerdtree']
" let g:sclow_block_buftypes=['terminal', 'prompt']
"
" " Disable scrollbar.
" """ let g:loaded_sclow = 1
"
" " Scrollbar display settings
" let g:sclow_bar_width=1          " Width of the scrollbar
" let g:sclow_bar_right_offset=-1  " Position of the scrollbar
" let g:sclow_hide_full_length=1   " Hide scrollbar when all content is visible
"
" " Use a subtle character for the scrollbar instead of solid line
" let g:sclow_sbar_text="┃"              " Scrollbar character (vertical line)
"
" " Configure scrollbar colors to match your theme
" augroup changeSclowHighlight
"     autocmd!
"     autocmd ColorScheme * hi SclowSbar ctermbg=NONE ctermfg=240 guibg=NONE guifg=#585858
" augroup END
"
" " Redraw the buffer when the window is scrolled.
" augroup FixScrollArtifacts
"     autocmd!
"     autocmd WinScrolled * call TimerRedraw()
" augroup END
"
" let s:redraw_timer = -1
" function! TimerRedraw() abort
"     if s:redraw_timer != -1
"         call timer_stop(s:redraw_timer)
"     endif
"     let s:redraw_timer = timer_start(1000, {-> execute('redraw!')}) " Time for redraw
" endfunction