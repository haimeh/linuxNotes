"compatability with st mouse scroll
set mouse=a
set ttymouse=sgr
"light color scheme looks better than dark
colorscheme gruvbox
let g:gruvbox_contrast_dark='hard'
set background=dark

"syntax highlighting
syntax on
"indent according to filetype
filetype indent plugin on
set omnifunc=syntaxcomplete#Complete
"highlight search matches (/ or :%s/thing/new/g)
set hlsearch
hi Search ctermfg=LightGreen ctermbg=Black
"highlight visual selection
hi Visual ctermfg=NONE ctermbg=Gray
"highlight spelling mistakes (:set spell)
hi SpellBad ctermbg=Red ctermfg=Black
"autocomplete menu colors (insertmode ctrl+n)
hi Pmenu ctermbg=Gray ctermfg=Black
hi PmenuSel ctermbg=LightGreen ctermfg=Black

"tab colors for multifile
hi TabLineFill ctermfg=Black 
hi TabLine ctermfg=Gray ctermbg=Black
hi TabLineSel ctermfg=Black ctermbg=LightGreen

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

"auto left after closing bracket or quote thing
inoremap {}  {}<Left>
inoremap ()  ()<Left>
inoremap ""  ""<Left>
inoremap ''  ''<Left>
inoremap []  []<Left>
