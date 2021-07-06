"compatability with st mouse scroll
set mouse=a
set ttymouse=sgr
"light color scheme looks better than dark
colorscheme gruvbox
let g:gruvbox_contrast_dark='hard'
let g:gruvbox_invert_selection='0'
set background=dark

"syntax highlighting
syntax on
filetype on
"indent according to filetype
filetype indent plugin on
set omnifunc=syntaxcomplete#Complete

"highlight search matches (/ or :%s/thing/new/g)
set hlsearch
set incsearch
hi Search ctermfg=LightGreen ctermbg=Black
"highlight visual selection
hi Visual ctermfg=NONE ctermbg=Gray
"highlight spelling mistakes (:set spell)
hi SpellBad ctermbg=Red ctermfg=Black
"autocomplete menu colors (insertmode ctrl+n)
hi Pmenu ctermbg=Gray ctermfg=Black
hi PmenuSel ctermbg=LightGreen ctermfg=Black

"tab colors less aggresive
hi TabLineFill ctermfg=Black 
hi TabLine ctermfg=Gray ctermbg=Black
hi TabLineSel ctermfg=Black ctermbg=LightGreen

hi Todo term=standout  ctermbg=Red ctermfg=Black guifg=Black guibg=Yellow

"https://en.wikipedia.org/wiki/Unicode_symbols
set list listchars=eol:┐,tab:⎢░,extends:►,precedes:◄,nbsp:▒,trail:◊
"set list listchars=eol:┐,tab:▹\ ◃,extends:⟩,precedes:⟨,nbsp:␣,trail:•
"set list listchars=eol:┐,tab:└┈┘,extends:⟩,precedes:⟨,nbsp:␣,trail:•
 
set tabstop=4 softtabstop=4
"spacify file or tabbify:
"set et
set expandtab!
"ret!

set wrap!
set noerrorbells
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile

"line numbers
":%s/^/\=printf('%-4d', line('.'))
set number relativenumber

"autocomplete aka <Tab> opens menu instead of inserting
set wildmenu
set wildmode=list:longest,full
" autocomplete but not from inside buffers (like file names)
inoremap <S-Tab> <C-X><C-F>

map <Leader>rc :e +108 $MYVIMRC<CR>

" what buffer delete feels like it should do
map <leader>bd :b#<bar>bd#<CR>

"REMINDER: 
"spell check
":setlocal spell spelllang=en_us
" ]s: previous misspell
" [s: previous misspell
" z=: select correction

" vim-sendtowindow reminders
"<space>l|k|j|h sends highlighted to the right|top|bottom|left, window
"
" pane reminders
"CTRL+w, v: Opens a new vertical split
"CTRL+w, c: Closes a window but keeps the buffer
"CTRL+w, o: Closes other windows, keeps the active window only
"CTRL+w, r: Moves the current window to the right
"CTRL+w, =: Makes all splits equal size
"CTRL+w, h|j|k|l: Switch active window by direction

"" Change 2 split windows from vert to horiz or horiz to vert
"changeVert CTRL+w K
"changeHori CTRL+w H
"map <Leader>th <C-w>t<C-w>H
"map <Leader>tk <C-w>t<C-w>K

":vert sb N
"which will open a left vertical split

" Window Splits
set splitbelow splitright

"REMINDER:
" CTRL+\, CTRL+N or CTRL+w, N: enter normal mode from terminal

map <Leader>tt :vert term<CR>
" Start terminals for R and Python sessions '\tr' or '\tp'
map <Leader>tr :term R<CR>
map <Leader>tp :term python3<CR>
map <Leader>ttr :vert term R<CR>
map <Leader>ttp :vert term python3<CR>
"command R !./%
"term make myprogram

"resize faster
"Ctrl+w _ will maximize a window vertically.
"Ctrl+w | will maximize a window horizontally.
nnoremap <silent> <C-w><Left> :vertical resize -5<CR>
nnoremap <silent> <C-w><Right> :vertical resize +5<CR>
nnoremap <silent> <C-w><Up> :resize +5<CR>
nnoremap <silent> <C-w><Down> :resize -5<CR>

" REMINDER: save and load vim sessions
":mksession! /path/to/myproject.vimsess
"vim -S /path/to/myproject.vimsess


"note open file tree with :Sex
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_liststyle = 3
"let g:netrw_winsize=25
let g:netrw_banner=0

"auto left after closing bracket or quote thing
inoremap {}  {}<Left>
inoremap ()  ()<Left>
inoremap ""  ""<Left>
inoremap ''  ''<Left>
inoremap []  []<Left>

