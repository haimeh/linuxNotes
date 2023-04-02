"compatability with st mouse scroll
"
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

" vim highlight the active line when in insert mode
set laststatus=2
set cursorline
hi CursorLine ctermbg=bg
hi StatusLine ctermfg=236
autocmd InsertEnter * highlight CursorLine ctermbg=236
autocmd InsertLeave * highlight CursorLine ctermbg=bg
au InsertEnter * hi StatusLine ctermbg=Green
au InsertLeave * hi StatusLine ctermbg=Red


"indent according to filetype
filetype indent plugin on
set omnifunc=syntaxcomplete#Complete


"highlight search matches (/ or :%s/thing/new/g)
"
set hlsearch
set incsearch
hi Search ctermfg=LightGreen ctermbg=Black
"highlight visual selection
"hi Visual ctermfg=NONE ctermbg=Gray
"highlight spelling mistakes (:set spell)
hi SpellBad ctermbg=Red ctermfg=Black
"autocomplete menu colors (insertmode ctrl+n)
hi Pmenu ctermbg=Gray ctermfg=Black
hi PmenuSel ctermbg=LightGreen ctermfg=Black

"tab colors less aggresive
"hi TabLineFill ctermfg=Black 
"hi TabLine ctermfg=Gray ctermbg=Black
"hi TabLineSel ctermfg=Black ctermbg=LightGreen

hi Todo term=standout  ctermbg=Red ctermfg=Black



"https://en.wikipedia.org/wiki/Unicode_symbols
set list listchars=eol:┐,tab:⎢░,extends:►,precedes:◄,nbsp:▒,trail:◊
"set list listchars=eol:┐,tab:├┄┤,extends:→,precedes:←,nbsp:␣,trail:•
"set list listchars=eol:┐,tab:∙\ ∙,extends:⟩,precedes:⟨,nbsp:␣,trail:╾ 

 

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
"inoremap <S-Tab> <C-X><C-F>
inoremap <Leader><Tab> <C-X><C-F>
"imap <C-N> <C-N><C-X><C-F>
"inoremap <C-N> <C-P><C-X><C-F>


" Default to not read-only in vimdiff
set noro


"NOTE: to retab the whole file
"ret!
set tabstop=4 softtabstop=4
"spacify file or tabbify:
set noexpandtab
"set expandtab!
"autocmd VimEnter * set noexpandtab
set pastetoggle=<F2>
" paste needed for expandtab! but prevents inoremap
"set nopaste


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
"inoremap : :<c-g>u
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
"
"COUNT WORDS:
" g CTRL+g
"
"PARAGRAPH WRAP:
":set textwidth=80
"Say my cursor was on the first line of a paragraph that I wanted to format. 
"The cursor can be on any column of that line for this to work:
"Shift-v }
"Then I would reformat that paragraph:
"gq
"
"ADD TRUE LINE NUMBERS:
"method 1:
" add zeros to all lines
" g CTRL-a
"method 2:
":%s/^/\=printf('%-4d', line('.'))
"
"ULTRA GREP:
":bufdo vimgrepadd yoursearchtermhere % | copen
"recurse through c files
":vimgrep /yoursearchtermhere/ **/*.c
"
"REPEAT WORDS:
"\(\<\w\+\>\)\_s*\<\1\>
""\(        \)                Capture the match so it can be reused later
"  \<    \>      \<  \>      Match (with zero-width) beginning/end of word
"    \w\+                    Match one or more word characters
"            \_s*            Match zero or more whitespace characters,
"                              including newlines
"                  \1        Match the same text as the first capture
"thus, to match any 3-digit number you could use the style of regex as follows
"\(\d\d\d\)\t\1
"

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

":vert sb filenameInBuffer
"which will open a buffer in left vertical split
":vs filenameInSystem
"which will open a file in left vertical split

" Window Splits
set splitbelow splitright


"NORMAL MODE IN TERMINAL BUFFER:
" CTRL+\, CTRL+N or 
" CTRL+w, N: enter normal mode from terminal

"QUICK RESIZE:
"Ctrl+w _ will maximize a window vertically.
"Ctrl+w | will maximize a window horizontally.
nnoremap <silent> <C-w><Left> :vertical resize -5<CR>
nnoremap <silent> <C-w><Right> :vertical resize +5<CR>
nnoremap <silent> <C-w><Up> :resize +5<CR>
nnoremap <silent> <C-w><Down> :resize -5<CR>


"auto left after closing bracket or quote thing
inoremap {} {}<Left>
inoremap () ()<Left>
inoremap "" ""<Left>
inoremap '' ''<Left>
inoremap [] []<Left>
"inoremap {<CR> {<CR>}<ESC>O
"inoremap {;<CR> {<CR>};<ESC>O


"note open file tree with :Sex
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_liststyle = 3
"let g:netrw_winsize=25
let g:netrw_banner=0

" SAVE AND LOAD VIM SESSIONS:
":mksession! /path/to/myproject.vi
"vim -S /path/to/myproject.vi

"OPEN INTERPRETERS:
map <Leader>t<space> :term ++rows=20<CR>
map <Leader>tt<space> :vert term<CR>
" Start terminals for R and Python sessions '\tr' or '\tp'
" Lisp exit can be hard..  q, (quit), [n] then ctrl-d.
map <Leader>tr :term ++rows=20 R<CR>
map <Leader>tp :term ++rows=20 python3<CR>
map <Leader>tl :term ++rows=20 sbcl --core /usr/lib64/sbcl/sbcl.core<CR>
map <Leader>tc :term ++rows=20 ~/.local/bin/reple -env cxx 
map <Leader>tu :term ++rows=20 ~/.local/bin/reple -env rust
map <Leader>ttr :vert term R<CR>
map <Leader>ttp :vert term python3<CR>
map <Leader>ttl :vert term sbcl --core /usr/lib64/sbcl/sbcl.core<CR>
map <Leader>ttc :vert term ~/.local/bin/reple -env cxx 
map <Leader>ttu :vert term ~/.local/bin/reple -env rust
"command R !./%
"term make myprogra

"groff preview
au BufNewFile,BufRead *.groff set filetype=groff
autocmd FileType groff map E :! groff -Tpdf -U -P-yU -e -ms % > preview.pdf; zathura preview.pdf & disown<CR><CR>
"autocmd FileType groff map E :! groff -ms hdtbl -Kutf8 -e -U % > preview.pdf; zathura preview.pdf & disown<CR><CR>
"requires dvips
"autocmd FileType groff map E :! groff -Tdvi -e -ms % > preview.dvi; dvipdf preview.dvi; rm preview.dvi; zathura preview.pdf & disown<CR><CR>
"autocmd FileType groff map E :! groff -Tpdf -P-e -e -ms % > preview.pdf; zathura preview.pdf & disown<CR><CR>
"autocmd FileType groff map E :! groff -Tps -e -mm  % > preview.ps; ps2pdf preview.ps; rm preview.ps; zathura preview.pdf & disown<CR><CR>

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

" TERMINAL C DEBUGGING GDB:
"Compile the code using the -g flag to include debugger information in the compiled program.
autocmd FileType cpp map E :! g++ -g % -o debugPreview
autocmd FileType c map E :! gcc -g % -o debugPreview
autocmd FileType rs map E :! rustc -g % --emit="obj,link"
"(also consider):Termdebug debugPreview
"
"To debug step through the code one instruction at a time 
"using si commmand (and occasional ni to skip over calls)
"
"Set breakpoints in thethingfunc and on line 23:
"b thethingfunc
"b 23
"
"To remove:
"clear 23
"
"To trigger when variable changes:
"watch myarray
"
"To see value of variable:
"print myarray[3]
"
"To start the program from vim or gdb term:
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
"
