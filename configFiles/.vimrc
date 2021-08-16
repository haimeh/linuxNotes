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

set number relativenumber

"autocomplete aka <Tab> opens menu instead of inserting
set wildmenu
set wildmode=list:longest,full
" autocomplete but not from inside buffers (like file names)
inoremap <S-Tab> <C-X><C-F>

"Make capital Y behave like capital D and C
" also remember, big J line concat
nnoremap Y y$

"Keep things more centered
nnoremap n nzzzv
nnoremap N Nzzzv
" mark spot, do J and go back to mark
nnoremap J mzJ`z

"visual mode move text chunk with indent rules
"the '< things denote selected region
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv


"undo breakpoints
inoremap <space> <space><c-g>u
inoremap . .<c-g>u
inoremap , ,<c-g>u
inoremap ; ;<c-g>u
inoremap : :<c-g>u
inoremap { {<c-g>u
inoremap [ [<c-g>u
inoremap ( (<c-g>u


map <Leader>rc :e +108 $MYVIMRC<CR>

" what buffer delete feels like it should do
map <leader>bd :b#<bar>bd#<CR>

"SPELL CHECK:
":setlocal spell spelllang=en_us
" ]s: previous misspell
" [s: previous misspell
" z=: select correction
"COUNT WORDS:
" g CTRL+g
"ADD TRUE LINE NUMBERS:
":%s/^/\=printf('%-4d', line('.'))
"ULTRA GREP:
":bufdo vimgrepadd yoursearchtermhere % | copen

"SENDTOWINDOW:
"<space>l|k|j|h sends highlighted to the right|top|bottom|left, window
"
"PANE MOVEMENTS:
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

"OPEN INTERPRETERS:
map <Leader>t : term<CR>
map <Leader>tt :vert term<CR>
" Start terminals for R and Python sessions '\tr' or '\tp'
map <Leader>tr :term R<CR>
map <Leader>tp :term python3<CR>
map <Leader>ttr :vert term R<CR>
map <Leader>ttp :vert term python3<CR>
"command R !./%
"term make myprogram
"NORMAL MODE IN TERMINAL BUFFER:
" CTRL+\, CTRL+N or CTRL+w, N: enter normal mode from terminal

"resize faster
"Ctrl+w _ will maximize a window vertically.
"Ctrl+w | will maximize a window horizontally.
nnoremap <silent> <C-w><Left> :vertical resize -5<CR>
nnoremap <silent> <C-w><Right> :vertical resize +5<CR>
nnoremap <silent> <C-w><Up> :resize +5<CR>
nnoremap <silent> <C-w><Down> :resize -5<CR>


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


" SAVE AND LOAD VIM SESSIONS:
":mksession! /path/to/myproject.vimsess
"vim -S /path/to/myproject.vimsess


"groff preview
au BufNewFile,BufRead *.groff set filetype=groff
autocmd FileType groff map I :! groff -e -ms % -T pdf > preview.pdf; zathura preview.pdf & disown<CR><CR>

" GO TO DEF:
"gd
" CTAGS:
set tags+=tags;$HOME
"Ctrl+] - go to def
"Ctrl+T - go back (from def)
"Ctrl+W Ctrl+] open def in split
"map <Leader>] :vsp <CR>:exec("tag ".expand("<cword>"))<CR>
":tjump - jump to definition or presents list
":ptag - open definition in preview window
":pc - close preview

" TERMINAL C DEBUGGING:
"Compile the code using the -g flag to include debugger information in the compiled program.
autocmd FileType cpp map I :! gcc -g % -o debugPreview
"(also consider):Termdebug debugPreview
"
"Set breakpoints in thethingfunc and on line 23
"b thethingfunc
"b 23
"
"To remove
"clear 23
"
"To trigger when variable changes
"watch myarray
"
"To see value of variable
"print myarray[3]
"
"To start the program from vim or gdb term
"run [args]
"
"step (to step into a function, see also stepi for assem)
"next (to step over a function, see also nexti for assem)
"continue (untill next break)
"
"list (to look at code chunk)
"layout next (to change view of debugging)
"ref (to refresh the view)
"quit (when done)
"

"DRAW JUNK:
"\di to start DrawIt and
"\ds to stop  DrawIt.
"
"<left>       move and draw left
"<s-left>     move left
"<space>      toggle into and out of erase mode
">            draw -> arrow
"\>           draw fat -> arrow
"<pgdn>       replace with a \, move down and right, and insert a \
"<end>        replace with a /, move down and left,  and insert a /
"<pgup>       replace with a /, move up   and right, and insert a /
"<home>       replace with a \, move up   and left,  and insert a \
"\a           draw arrow based on corners of visual-block
"\b           draw box using visual-block selected region
"\e           draw an ellipse inside visual-block
"\f           fill a figure with some character
"\h           create a canvas for \a \b \e \l
"\l           draw line based on corners of visual block
"\s           adds spaces to canvas
"\ra ... \rz  replace text with given brush/register
"\pa ...      like \ra ... \rz, except that blanks are considered
"             to be transparent
