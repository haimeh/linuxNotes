"compatability with st mouse scroll
set mouse=a
set ttymouse=sgr
"light color scheme looks better than dark
colorscheme gruvbox_community
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

"https://en.wikipedia.org/wiki/Unicode_symbols
"set list listchars=eol:┐,tab:·\ ·,extends:⟩,precedes:⟨,nbsp:␣,trail:•
"set list listchars=eol:┐,tab:⋅\ ┘,extends:⟩,precedes:⟨,nbsp:␣,trail:•
set list listchars=eol:┐,tab:⎢░,extends:⟩,precedes:⟨,nbsp:▒,trail:◊
"set list listchars=eol:┐,tab:▹\ ◃,extends:⟩,precedes:⟨,nbsp:␣,trail:•
"set list listchars=eol:┐,tab:└┈┘,extends:⟩,precedes:⟨,nbsp:␣,trail:•
 
set tabstop=4 softtabstop=4
"spacify file or tabbify:
"set et
set et!
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


"open term (Leader means \)
map <Leader>tv :vert term<CR>
map <Leader>ts :term<CR>

"pane reminders
"CTRL+w, v: Opens a new vertical split
"CTRL+w, c: Closes a window but keeps the buffer
"CTRL+w, o: Closes other windows, keeps the active window only
"CTRL+w, r: Moves the current window to the right
"CTRL+w, =: Makes all splits equal size

"changeVert CTRL+w K
"changeHori CTRL+w H
"
"simpler pane reorientation
"map <Leader>th <C-w>t<C-w>H
"map <Leader>tk <C-w>t<C-w>K

"simpler window movement
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k

"resize faster
nnoremap <silent> <C-w><Left> :vertical resize +10<CR>
nnoremap <silent> <C-w><Right> :vertical resize -10<CR>
nnoremap <silent> <C-w><Up> :resize +10<CR>
nnoremap <silent> <C-w><Down> :resize -10<CR>

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

