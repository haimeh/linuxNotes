"compatability with st mouse scroll
set mouse=a
set ttymouse=sgr
"syntax highlighting
syntax on
"indent according to filetype
filetype indent plugin on
set omnifunc=syntaxcomplete#Complete
"highlight search matches (/ or :%s/thing/new/g)
set hlsearch
hi Search ctermbg=LightGreen
hi Search ctermfg=Black
"highlight spelling mistakes (:set spell)
hi SpellBad ctermbg=Red
hi SpellBad ctermfg=Black
"autocomplete menu colors (insertmode ctrl+n)
hi Pmenu ctermbg=Gray
hi Pmenu ctermfg=Black
hi PmenuSel ctermbg=LightGreen
hi PmenuSel ctermfg=Black

"line numbers
set number relativenumber
"autocomplete aka <Tab> opens menu instead of inserting
set wildmenu
set wildmode=list:longest,full
"open file tree with :Sex
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_liststyle = 3
"let g:netrw_winsize=25
let g:netrw_banner=0
