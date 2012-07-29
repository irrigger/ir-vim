" My new .vimrc will start here.
" Time to start seriously taking
" advantage of this program

" ================================================ Notes ===

" gui_w32.txt Windows specific junk
" os_unix.txt Some Unix stuff

" internal-variables Information on variable namespaces

" ==================================== Start Up Settings ===

call pathogen#infect()

" Do not try to be VI compatible
set nocompatible
" Syntax highlighing
syntax on
" Try to detect filetypes
filetype on
" Enable loading indent file for filetype
filetype plugin indent on

let irdata = '_data'
let irdirs = {'backupdir': 'backup', 'dir': 'swap', 'undodir': 'undo'}
let irsplit = '/'
let irroot = '.vim'
if has("win32")
    if has("autocmd")
        " Starts gvim in full screen mode
        autocmd GUIEnter * simalt ~x
        " Get rid of this flash crap whenever a buffer is entered
        autocmd GUIEnter * set visualbell t_vb=
    endif
    let irsplit = '\\'
    let irroot = 'vimfiles'

    " Remove special windows keys (copy/paste/etc)
    set keymodel=

elseif has("unix")
    " Some attempts at nice fonts
    set guifont=Courier\ 10,DejaVu\ Sans\ Mono\ 9
    " Path to dictionary for vim to use in completion
    set dictionary+=/usr/share/dict/words

elseif has("gui_macvim")
    set lines=75
    set columns=78

endif

" Let's create our _data directory in the vim root.
let irdirname = expand('~' . irsplit . irroot . irsplit . irdata)
if !isdirectory(irdirname)
    call mkdir(irdirname)
endif

" Create the dirs we need.  A little loop will do just fine.
" We'll also go ahead and assign the directories to their options.
for dir in keys(irdirs)
    let tmp = irdirname . irsplit . irdirs[dir]
    if !isdirectory(tmp)
        call mkdir(tmp)
    endif
    let cmd = "set " . dir . "=" . tmp
    exec cmd
endfor

if has("gui_running")
    " Highlight the cursor line
    set cul
    " Highlight the cursor column
    set cuc
    " Make the mouse disappear when in vim
    set mousehide
    " Give me just the code area. No need for toolbars
    set guioptions=ac
    " My colorsceme
    colorscheme molokai
    let g:molokai_original=0
else
    " Adapt colors for dark background
    set background=dark
    set t_Co=256
endif

" ======================================= Basic Settings ===
" Make command line one line high
set ch=1
" Keep 3 lines when scrolling
set scrolloff=3
" Always set autoindenting on
set autoindent
" Turn off erroring and beeping
set noerrorbells
" Show title in console title bar
set title
" Don't jump to first character when paging
set nostartofline
" Start,indent,eol
set backspace=2
" Show matching <> (html mainly) as well
set matchpairs+=<:>
" Jump to matching brace immediately after insert
set showmatch
" Time vim will sit on the matching brace
set matchtime=3
" Abbreviate messages
set shortmess=atI
" Highlight search items
set hlsearch
" Tab complete commands
set wildmenu
" Complete from a Thesaurus if possible
set complete+=s
" List longest first. Don't know if I want this
set wildmode=list:longest,full
" Whoever wanted to modify a .pyc?
set wildignore+=*.pyc
" Give me lots of Undos
set history=10000
" Let my cursor go everywhere
set virtualedit=all
" Search as I type
set incsearch
" Use the / instead of \
set shellslash
" No word wrap
set nowrap
" Settings for vim to remember stuff on startup :help viminfo
set viminfo='100,/100,:100,@100
" Always show status line
set laststatus=2
" Harder to explain but an awesome statusline just for me
" %r tells me if the file is readonly
" %{expand('%:p')} gives me the full path to the file
" %l/%L current line and total lines
" %v current column
set statusline=%r\ F:%{expand('%:p')}\ L:%l/%L\ C:%v
" This removes the characters between split windows (and some other junk)
set fillchars="-"
" This allows vim to work with buffers much more liberally. So no warnings when switching modified buffers
set hidden
" Persistent undos
set undofile
" What information to lsave when creating a session.
set sessionoptions=buffers,resize,winpos,winsize
" Turning the mouse off.  Suck it mouse users.
set mouse=""

if has("autocmd")

    " Stolen from TPetticrew's vimrc
    " Remove line/column selection on inactive panes
    autocmd WinEnter * setlocal cursorline
    autocmd WinLeave * setlocal nocursorline
    autocmd WinEnter * setlocal cursorcolumn
    autocmd WinLeave * setlocal nocursorcolumn

    " Automatically delete trailing white spaces
    autocmd BufEnter,BufRead,BufWrite * silent! %s/[\r \t]\+$//
    autocmd BufEnter *.php :%s/[ \t\r]\+$//e
    " Set current directory to that of the opened files
    autocmd BufEnter,BufWrite * lcd %:p:h
    " Set default textwidth
    autocmd BufEnter * let b:textwidth=80

	" If a MayaAsii file hightlight as if a mel file
    autocmd BufRead,BufNewFile *.ma setf mel

    " Ensure that all my auto formating is minimal
    autocmd Filetype * setlocal formatoptions=t

    " Filetype specific tabbing
    autocmd FileType * setlocal ts=4 sts=4 sw=4 noexpandtab cindent
    autocmd FileType python,vim,vimrc setlocal ts=4 sts=4 sw=4 expandtab

    " Filetype specific comment leaders
    autocmd FileType * let b:comment_leader = ''
    autocmd FileType vim,vimrc let b:comment_leader = '" '
    autocmd FileType haskell,vhdl,ada let b:comment_leader = '-- '
    autocmd FileType c,cpp,java,mel let b:comment_leader = '// '
    autocmd FileType sh,make,python,tcsh let b:comment_leader = '# '
    autocmd FileType tex let b:comment_leader = '% '

    autocmd Filetype python let b:textwidth=79

endif

" Setup command to easily call to run python buffer
command! RunPythonBuffer call DoRunPythonBuffer()
" Run current buffer in python
map <leader>p :RunPythonBuffer<CR>
" Echo current file path and put in middle mouse buffer
map <leader>f :let @*=expand('%:p')<CR>:echom @*<CR>

" ========================================== Key Binding ===
" Match the lines that are too long.
nmap <leader>m :call ToggleLineLengthHilight()<CR>
" Shortcut to grab last inserted text
nmap gV `[v`]
" Turning off the stupid man pages thing
map K <Nop>
" Shortcut to rapidly toggle `set list`
nmap <leader>l :set list!<CR>
" This if for custom wrap toggle
nmap <silent> <leader>w :set invwrap<CR>:set wrap?<CR>
" Clear highlights with spacebar
nmap <silent> <Space> :nohlsearch <CR>
" Allow me to scroll horizontally
nmap <silent> <leader>o 30zl
nmap <silent> <leader>i 30zh
" Allows the resizing windows horizontally
noremap <leader>. <C-w>20>
noremap <leader>, <C-w>20<
" Map to quickly open and reload my vimrc
map <leader>v :e $MYVIMRC<CR><C-W>_
map <silent> <leader>V :source $MYVIMRC<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>
" Sometimes I don't want spelling
nmap <leader>s :setlocal spell! spelllang=en_gb<CR>
" New commenting and uncommenting procs
map ,c :call CommentLine()<CR>
map ,u :call UncommentLine()<CR>

" ====================================== Plugin Settings ===
"Additional python syntax highlighting
let python_highlight_all=1

" Gundo Plugin
nnoremap <F5> :GundoToggle<CR>

