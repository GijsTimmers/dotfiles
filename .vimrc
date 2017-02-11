syntax on
set noshowmode
set hidden
filetype plugin indent on
set ignorecase smartcase

" Geen swapfiles graag
set noswapfile

" Pathogen aanzetten voor plugins
execute pathogen#infect()

" tab = 4 spaties
set shiftwidth=4
set tabstop=4
set expandtab

" jk kan gebruikt worden ipv Escape in INSERT-modus
inoremap jk <Esc>

" Snel naar normale modus na indrukken van Escape
" Gebruik dit icm:
" dconf write "/org/gnome/desktop/input-sources/xkb-options" "['caps:swapescape']"
inoremap <Esc> <Esc>

" Plakken vanuit het X11-klembord op een schone manier (vereist vim-gtk).
vnoremap <C-c> "+y:echo "Gekopieerd naar systeemklembord"<CR>
inoremap <C-v> <Esc>"+p:echo "Geplakt uit systeemklembord"<CR>a
vnoremap <C-v> <Esc>"+p:echo "Geplakt uit systeemklembord"<CR>

" Laatste macro uitvoeren met Q
map Q @@

" Fijne splitnavigatie
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l


" Regelnummers aan-/uitzetten
function! NummerSwitch()
    if &number==0 && &relativenumber==0
      set number
    elseif &number==1 && &relativenumber==0
        set nonumber
        set relativenumber
    elseif &number==0 && &relativenumber==1
        set norelativenumber
    endif
endfunction
set relativenumber
set number
"nnoremap <silent> <C-n> :call NummerSwitch()<CR>
" nnoremap <C-n> :exec &number==&relativenumber? "se number!" : "se relativenumber!"<CR>

" Sneltoets: ; gebruiken als :
nnoremap ; :
vnoremap ; :

" Sneltoets: zoekopdracht herhalen met ' ipv ;
noremap ' ;

" Sneltoets: J en K gebruiken voor volgende/vorige buffer
noremap J :bn<CR>
noremap K :bp<CR>

" Sneltoets: F5 draait dit bestand.
nnoremap <F5> :!clear;%:p 
inoremap <F5> <Esc> :!clear;%:p 

" Sneltoets: F11 past direct ~/.vimrc aan in een nieuwe buffer
nnoremap <F11> :e ~/.vimrc<CR>
inoremap <F11> <Esc> :e ~/.vimrc<CR>

" Sneltoets: F12 slaat op en sourcet ~/.vimrc
if !exists("*ReloadConfigs")
  function ReloadConfigs()
      :source ~/.vimrc
  endfunction
  command! Recfg call ReloadConfigs()
endif
nnoremap <F12> :w <bar> Recfg<CR>
            \:echo "Opgeslagen en ~/.vimrc opnieuw ingeladen."<CR>
inoremap <F12> <Esc>:w <bar> Recfg<CR>
            \:echo "Opgeslagen en ~/.vimrc opnieuw ingeladen."<CR>

" Bij zoeken de match oplichten
function! HLNext (blinktime)
  highlight WhiteOnRed ctermfg=white ctermbg=red
  let [bufnum, lnum, col, off] = getpos('.')
  let matchlen = strlen(matchstr(strpart(getline('.'),col-1),@/))
  let target_pat = '\c\%#'.@/
  let ring = matchadd('WhiteOnRed', target_pat, 101)
  redraw
  exec 'sleep ' . a:blinktime . 'm'
  call matchdelete(ring)
  redraw
endfunction
" set hlsearch
nnoremap <silent> <space> :set hlsearch! hlsearch?<CR>
nnoremap <silent> n   n:call HLNext(300)<cr>
nnoremap <silent> N   N:call HLNext(300)<cr>

" Beter scrollen
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

" Blokken code commenten
function! Comment_Or_Uncomment()
    let hekjelijst = ["python", "sh", "zsh", "bash", "ruby", "conf", "fstab", "yaml"]
    let slashlijst = ["c", "cpp", "java", "scala"]
    let quotedblocklijst= ["vim"]
    let percentlijst = ["tex"]
    if index(quotedblocklijst, &filetype)>=0
        let b:comment_leader = "\""
    elseif index(hekjelijst, &filetype)>=0
        let b:comment_leader = "#"
    elseif index(percentlijst, &filetype)>=0
        let b:comment_leader = "%"
    elseif index(slashlijst, &filetype)>=0
        let b:comment_leader = "\\/\\/"
    else
        let b:comment_leader = "#"
    endif
    let l:save_cursor = getpos(".")
    let first_char = getline(".")[0]
    if synIDattr(synIDtrans(synID(line("."), col("."), 0)), "name") == "Comment"
        execute "s/^" . b:comment_leader . "//"
        let length_of_comment_prefix = len(b:comment_leader)
        let l:save_cursor[2] = l:save_cursor[2] - length_of_comment_prefix
        call setpos(".", l:save_cursor)
    else
        execute "s/^/" . b:comment_leader . "/"
        let length_of_comment_prefix = len(b:comment_leader)
        let l:save_cursor[2] = l:save_cursor[2] + length_of_comment_prefix
        call setpos(".", l:save_cursor)
    endif
endfunction

nnoremap <silent> # :call Comment_Or_Uncomment()<CR>
vnoremap <silent> # :call Comment_Or_Uncomment()<CR>gv

" Sneltoets: Ctrl-T opent een nieuwe buffer, en start een bestandsbeheerder 
" op om het bestand te selecteren.
nnoremap <C-t> :Explore<CR>
inoremap <C-t> <Esc>:Explore<CR>

" Sneltoets: Ctrl-S slaat op en keert evt direct terug naar insert mode.
inoremap <C-s> <Esc>:w<CR>:echo "Opgeslagen"<CR>a
nnoremap <C-s>      :w<CR>:echo "Opgeslagen"<CR>

" Sneltoets: Ctrl-W of Ctrl-Q sluiten de huidige buffer zonder op te slaan.
" Indien dit de laatste buffer is, wordt er gewoon afgesloten zonder op te
" slaan.
function! AangepastAfsluiten()
    let bufcount = len(filter(range(1,bufnr('$')), 'buflisted(v:val)==1'))
    if bufcount < 2
        q!
    else
        bd!
    endif
endfunction
nnoremap <C-q> :call AangepastAfsluiten()<CR>:echo "Gesloten"<CR>
inoremap <C-q> <Esc>:call AangepastAfsluiten()<CR>:echo "Gesloten"<CR>

" Sneltoets: Ctrl-X slaat de huidige buffer op en sluit deze daarna. 
function! AangepastOpslaanEnAfsluiten()
    let bufcount = len(filter(range(1,bufnr('$')), 'buflisted(v:val)==1'))
    if bufcount < 2
        write
        q
    else
        write
        bdelete
    endif
endfunction
nnoremap <C-x> :call AangepastOpslaanEnAfsluiten()<CR>
            \:echo "Opgeslagen en gesloten"<CR>
inoremap <C-x> <Esc>:call AangepastOpslaanEnAfsluiten()<CR>\
            \:echo "Opgeslagen en gesloten"<CR>

" Tab om aan te vullen
function! Tab_Or_Complete()
  if col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
    return "\<C-N>"
  else
    return "\<Tab>"
  endif
endfunction
inoremap <Tab> <C-R>=Tab_Or_Complete()<CR>

" Pijltjestoetsen uitzetten
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

" vim-airline-instellingen
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#branch#enabled=1
let g:airline_powerline_fonts = 1
" let g:airline_theme="molokai"
"let g:airline_theme="cobalt2"
let g:airline_theme="powerlineish"
set laststatus=2
if !exists('g:airline_symbols')
let g:airline_symbols = {}
endif
let g:airline_symbols.linenr = ""
let g:airline#extensions#whitespace#enabled = 0

" netrw-instellingen
" Verborgen items standaard verbergen (laat zien met a)
let g:netrw_list_hide="^\\..*"
let g:netrw_hide=1
" Banner bovenin standaard verbergen (herstel met I)
let g:netrw_banner=0

" En uiteindelijk het scherm maximaliseren
"set lines=999 columns=999

