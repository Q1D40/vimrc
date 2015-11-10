"/////////////////////////////////////////////////////////////////////////////
" basic
"/////////////////////////////////////////////////////////////////////////////

set nocompatible " be iMproved, required

function! OSX()
    return has('macunix')
endfunction
function! LINUX()
    return has('unix') && !has('macunix') && !has('win32unix')
endfunction
function! WINDOWS()
    return  (has('win16') || has('win32') || has('win64'))
endfunction

" On Windows, also use '.vim' instead of 'vimfiles'; this makes synchronization
" across (heterogeneous) systems easier.
if WINDOWS()
    set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
endif

"/////////////////////////////////////////////////////////////////////////////
" language and encoding setup
"/////////////////////////////////////////////////////////////////////////////

" always use English menu
" NOTE: this must before filetype off, otherwise it won't work
set langmenu=none

" use English for anaything in vim-editor.
if WINDOWS()
    silent exec 'language english'
elseif OSX()
    silent exec 'language en_US'
else
    let s:uname = system("uname -s")
    if s:uname == "Darwin\n"
        " in mac-terminal
        silent exec 'language en_US'
    else
        " in linux-terminal
        silent exec 'language en_US.utf8'
    endif
endif

" try to set encoding to utf-8
if WINDOWS()
    " Be nice and check for multi_byte even if the config requires
    " multi_byte support most of the time
    if has('multi_byte')
        " Windows cmd.exe still uses cp850. If Windows ever moved to
        " Powershell as the primary terminal, this would be utf-8
        set termencoding=cp850
        " Let Vim use utf-8 internally, because many scripts require this
        set encoding=utf-8
        setglobal fileencoding=utf-8
        " Windows has traditionally used cp1252, so it's probably wise to
        " fallback into cp1252 instead of eg. iso-8859-15.
        " Newer Windows files might contain utf-8 or utf-16 LE so we might
        " want to try them first.
        set fileencodings=ucs-bom,utf-8,utf-16le,cp1252,iso-8859-15
    endif

else
    " set default encoding to utf-8
    set encoding=utf-8
    set termencoding=utf-8
endif
scriptencoding utf-8

"/////////////////////////////////////////////////////////////////////////////
" Bundle steup
"/////////////////////////////////////////////////////////////////////////////

" vundle#begin
filetype off " required

" set the runtime path to include Vundle
set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#rc('~/.vim/bundle/')

" vundle#end
filetype plugin indent on " required
syntax on " required

"/////////////////////////////////////////////////////////////////////////////
" Default colorscheme setup
"/////////////////////////////////////////////////////////////////////////////

if has('gui_running')
    set background=dark
else
    set background=dark
    set t_Co=256 " make sure our terminal use 256 color
    " let g:solarized_termcolors = 256
endif
" colorscheme hybrid
" colorscheme solarized
" colorscheme exlightgray

"/////////////////////////////////////////////////////////////////////////////
" General
"/////////////////////////////////////////////////////////////////////////////

"set path=.,/usr/include/*,, " where gf, ^Wf, :find will search
set backup " make backup file and leave it around

" setup back and swap directory
let data_dir = $HOME.'/.data/'
let backup_dir = data_dir . 'backup'
let swap_dir = data_dir . 'swap'
if finddir(data_dir) == ''
    silent call mkdir(data_dir)
endif
if finddir(backup_dir) == ''
    silent call mkdir(backup_dir)
endif
if finddir(swap_dir) == ''
    silent call mkdir(swap_dir)
endif
unlet backup_dir
unlet swap_dir
unlet data_dir

set backupdir=$HOME/.data/backup " where to put backup file
set directory=$HOME/.data/swap " where to put swap file

" Redefine the shell redirection operator to receive both the stderr messages and stdout messages
set shellredir=>%s\ 2>&1
set history=50 " keep 50 lines of command line history
set updatetime=1000 " default = 4000
set autoread " auto read same-file change ( better for vc/vim change )
set maxmempattern=1000 " enlarge maxmempattern from 1000 to ... (2000000 will give it without limit)

"/////////////////////////////////////////////////////////////////////////////
" xterm settings
"/////////////////////////////////////////////////////////////////////////////

behave xterm  " set mouse behavior as xterm
if &term =~ 'xterm'
    set mouse=a
endif

"/////////////////////////////////////////////////////////////////////////////
" Variable settings ( set all )
"/////////////////////////////////////////////////////////////////////////////

" ------------------------------------------------------------------
" Desc: Visual
" ------------------------------------------------------------------

set matchtime=0 " 0 second to show the matching paren ( much faster )
set nu " show line number
set rnu
set scrolloff=0 " minimal number of screen lines to keep above and below the cursor
set nowrap " do not wrap text

" only supoort in 7.3 or higher
if v:version >= 703
    set noacd " no autochchdir
endif

" set default guifont
if has('gui_running')
    augroup ex_gui_font
        " check and determine the gui font after GUIEnter.
        " NOTE: getfontname function only works after GUIEnter.
        au!
        au GUIEnter * call s:set_gui_font()
    augroup END

    " set guifont
    function! s:set_gui_font()
        if has('gui_gtk2')
            if getfontname( 'DejaVu Sans Mono for Powerline' ) != ''
                set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 12
            elseif getfontname( 'DejaVu Sans Mono' ) != ''
                set guifont=DejaVu\ Sans\ Mono\ 12
            else
                set guifont=Luxi\ Mono\ 12
            endif
        elseif has('x11')
            " Also for GTK 1
            set guifont=*-lucidatypewriter-medium-r-normal-*-*-180-*-*-m-*-*
        elseif OSX()
            if getfontname( 'DejaVu Sans Mono for Powerline' ) != ''
                set guifont=DejaVu\ Sans\ Mono\ for\ Powerline:h15
            elseif getfontname( 'DejaVu Sans Mono' ) != ''
                set guifont=DejaVu\ Sans\ Mono:h15
            endif
        elseif WINDOWS()
            if getfontname( 'DejaVu Sans Mono for Powerline' ) != ''
                set guifont=DejaVu\ Sans\ Mono\ for\ Powerline:h11:cANSI
            elseif getfontname( 'DejaVu Sans Mono' ) != ''
                set guifont=DejaVu\ Sans\ Mono:h11:cANSI
            elseif getfontname( 'Consolas' ) != ''
                set guifont=Consolas:h11:cANSI " this is the default visual studio font
            else
                set guifont=Lucida_Console:h11:cANSI
            endif
        endif
    endfunction
endif

" ------------------------------------------------------------------
" Desc: Vim UI
" ------------------------------------------------------------------

set wildmenu " turn on wild menu, try typing :h and press <Tab>
set showcmd " display incomplete commands
set cmdheight=1 " 1 screen lines to use for the command-line
set ruler " show the cursor position all the time
set hidden " allow to change buffer without saving
set shortmess=aoOtTI " shortens messages to avoid 'press a key' prompt
set lazyredraw " do not redraw while executing macros (much faster)
set display+=lastline " for easy browse last line with wrap text
set laststatus=2 " always have status-line
set titlestring=%t\ (%{expand(\"%:p:.:h\")}/)

" set window size (if it's GUI)
if has('gui_running')
    " set window's width to 130 columns and height to 40 rows
    if exists('+lines')
        set lines=40
    endif
    if exists('+columns')
        set columns=130
    endif

    " DISABLE
    " if WINDOWS()
    "     au GUIEnter * simalt ~x " Maximize window when enter vim
    " else
    "     " TODO: no way right now
    " endif
endif

set showfulltag " show tag with function protype.
set guioptions+=b " present the bottom scrollbar when the longest visible line exceed the window

" disable menu & toolbar
set guioptions-=m
set guioptions-=T

" ------------------------------------------------------------------
" Desc: Text edit
" ------------------------------------------------------------------

set ai " autoindent
set si " smartindent
set backspace=indent,eol,start " allow backspacing over everything in insert mode
" indent options
" see help cinoptions-values for more details
set	cinoptions=>s,e0,n0,f0,{0,}0,^0,:0,=s,l0,b0,g0,hs,ps,ts,is,+s,c3,C0,0,(0,us,U0,w0,W0,m0,j0,)20,*30
" default '0{,0},0),:,0#,!^F,o,O,e' disable 0# for not ident preprocess
" set cinkeys=0{,0},0),:,!^F,o,O,e

" official diff settings
set diffexpr=g:MyDiff()
function! g:MyDiff()
    let opt = '-a --binary -w '
    if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
    if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
    let arg1 = v:fname_in
    if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
    let arg2 = v:fname_new
    if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
    let arg3 = v:fname_out
    if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
    silent execute '!' .  'diff ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
endfunction

set cindent shiftwidth=4 " set cindent on to autoinent when editing c/c++ file, with 4 shift width
set tabstop=4 " set tabstop to 4 characters
set expandtab " set expandtab on, the tab will be change to space automaticaly
set ve=block " in visual block mode, cursor can be positioned where there is no actual character

" set Number format to null(default is octal) , when press CTRL-A on number
" like 007, it would not become 010
set nf=

" ------------------------------------------------------------------
" Desc: Fold text
" ------------------------------------------------------------------

set foldmethod=marker foldmarker={,} foldlevel=9999
set diffopt=filler,context:9999

" ------------------------------------------------------------------
" Desc: Search
" ------------------------------------------------------------------

set showmatch " show matching paren
set incsearch " do incremental searching
set hlsearch " highlight search terms
set ignorecase " set search/replace pattern to ignore case
set smartcase " set smartcase mode on, If there is upper case character in the search patern, the 'ignorecase' option will be override.

" set this to use id-utils for global search
set grepprg=lid\ -Rgrep\ -s
set grepformat=%f:%l:%m

"/////////////////////////////////////////////////////////////////////////////
" Auto Command
"/////////////////////////////////////////////////////////////////////////////

" ------------------------------------------------------------------
" Desc: Only do this part when compiled with support for autocommands.
" ------------------------------------------------------------------

if has('autocmd')

    augroup ex
        au!

        " ------------------------------------------------------------------
        " Desc: Buffer
        " ------------------------------------------------------------------

        " when editing a file, always jump to the last known cursor position.
        " don't do it when the position is invalid or when inside an event handler
        " (happens when dropping a file on gvim).
        au BufReadPost *
                    \ if line("'\"") > 0 && line("'\"") <= line("$") |
                    \   exe "normal g`\"" |
                    \ endif
        au BufNewFile,BufEnter * set cpoptions+=d " NOTE: ctags find the tags file from the current path instead of the path of currect file
        au BufEnter * :syntax sync fromstart " ensure every file does syntax highlighting (full)
        au BufNewFile,BufRead *.avs set syntax=avs " for avs syntax file.

        " DISABLE {
        " NOTE: will have problem with exvim, because exvim use exES_CWD as working directory for tag and other thing
        " Change current directory to the file of the buffer ( from Script#65"CD.vim"
        " au   BufEnter *   execute ":lcd " . expand("%:p:h")
        " } DISABLE end

        " ------------------------------------------------------------------
        " Desc: file types
        " ------------------------------------------------------------------

        au FileType text setlocal textwidth=78 " for all text files set 'textwidth' to 78 characters.
        au FileType c,cpp,cs,swig set nomodeline " this will avoid bug in my project with namespace ex, the vim will tree ex:: as modeline.

        au FileType javascript set cindent shiftwidth=2 " set cindent on to autoinent when editing javascript file, with 2 shift width
        au FileType javascript set tabstop=2 " set tabstop to 2 characters

        " disable auto-comment for c/cpp, lua, javascript, c# and vim-script
        au FileType c,cpp,java,javascript set comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,f://
        au FileType cs set comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,f:///,f://
        au FileType vim set comments=sO:\"\ -,mO:\"\ \ ,eO:\"\",f:\"
        au FileType lua set comments=f:--

        " if edit python scripts, check if have \t. ( python said: the programme can only use \t or not, but can't use them together )
        au FileType python,coffee call s:check_if_expand_tab()
    augroup END

    function! s:check_if_expand_tab()
        let has_noexpandtab = search('^\t','wn')
        let has_expandtab = search('^    ','wn')

        "
        if has_noexpandtab && has_expandtab
            let idx = inputlist ( ['ERROR: current file exists both expand and noexpand TAB, python can only use one of these two mode in one file.\nSelect Tab Expand Type:',
                        \ '1. expand (tab=space, recommended)',
                        \ '2. noexpand (tab=\t, currently have risk)',
                        \ '3. do nothing (I will handle it by myself)'])
            let tab_space = printf('%*s',&tabstop,'')
            if idx == 1
                let has_noexpandtab = 0
                let has_expandtab = 1
                silent exec '%s/\t/' . tab_space . '/g'
            elseif idx == 2
                let has_noexpandtab = 1
                let has_expandtab = 0
                silent exec '%s/' . tab_space . '/\t/g'
            else
                return
            endif
        endif

        "
        if has_noexpandtab == 1 && has_expandtab == 0
            echomsg 'substitute space to TAB...'
            set noexpandtab
            echomsg 'done!'
        elseif has_noexpandtab == 0 && has_expandtab == 1
            echomsg 'substitute TAB to space...'
            set expandtab
            echomsg 'done!'
        else
            " it may be a new file
            " we use original vim setting
        endif
    endfunction
endif

"/////////////////////////////////////////////////////////////////////////////
" plugin start
"/////////////////////////////////////////////////////////////////////////////

" Vundle

" man.vim
source $VIMRUNTIME/ftplugin/man.vim

" Vundle
" ---------------------------------------------------
Plugin 'gmarik/Vundle.vim'

" vim-color-solarized
" ---------------------------------------------------
Plugin 'altercation/vim-colors-solarized'

" vim-airline
" ---------------------------------------------------
Plugin 'bling/vim-airline'

if has('gui_running')
    let g:airline_powerline_fonts = 1
else
    let g:airline_powerline_fonts = 1
    " let g:airline_powerline_fonts = 0
endif

let g:airline#extensions#tabline#enabled = 0 " NOTE: When you open lots of buffers and typing text, it is so slow.
let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#fnamemod = ':t'
" let g:airline_section_b = "%{fnamemodify(bufname('%'),':p:.:h').'/'}"
" let g:airline_section_c = '%t'
" let g:airline_section_warning = airline#section#create(['whitespace']) " NOTE: airline#section#create has no effect in .vimrc initialize pahse
" let g:airline_section_warning = '%{airline#util#wrap(airline#extensions#whitespace#check(),0)}'
let g:airline_section_warning = ''

" ctrlp: invoke by <ctrl-p>
" Plugin 'kien/ctrlp.vim'
" let g:ctrlp_working_path_mode = ''
" let g:ctrlp_match_window = 'bottom,order:ttb,min:1,max:10,results:10'
" let g:ctrlp_follow_symlinks = 2
" let g:ctrlp_max_files = 0 " Unset cap of 10,000 files so we find everything
" nnoremap <unique> <leader>bs :CtrlPBuffer<CR>

" vim-fugitive
" ---------------------------------------------------
Plugin 'tpope/vim-fugitive'

" vim-surround
" ---------------------------------------------------
Plugin 'tpope/vim-surround'

xmap s <Plug>VSurround

" Plugin 'tpope/vim-dispatch'

" nerdtree
" ---------------------------------------------------
Plugin 'scrooloose/nerdtree'

let g:NERDTreeWinSize = 30
let g:NERDTreeMouseMode = 1
let g:NERDTreeMapToggleZoom = '<Space>'

map <C-n> :NERDTreeToggle<CR>

" nerdcommenter
" ---------------------------------------------------
" Plugin 'scrooloose/nerdcommenter'
"
" let g:NERDSpaceDelims = 1
" let g:NERDRemoveExtraSpaces = 1
" let g:NERDCustomDelimiters = {
"             \ 'vimentry': { 'left': '--' },
"             \ }
" map <unique> <F11> <Plug>NERDCommenterAlignBoth
" map <unique> <C-F11> <Plug>NERDCommenterUncomment

" syntastic
" ---------------------------------------------------
" Plugin 'scrooloose/syntastic'

" this will make html file by Angular.js ignore errors
" let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute \"ng-"]

" neocomplcache.vim
" " ---------------------------------------------------
" Plugin 'Shougo/neocomplcache.vim'

" let g:neocomplcache_enable_at_startup = 1
" let g:neocomplcache_auto_completion_start_length = 2
" let g:neocomplcache_enable_smart_case = 1
" let g:neocomplcache_enable_auto_select = 1 " let neocomplcache's completion behavior like AutoComplPop
" let g:neocomplcache_disable_auto_complete = 1 " Enable this if you like TAB for complete
" " inoremap <C-p> <C-x><C-u>
" " inoremap <expr><TAB>  pumvisible() ? '\<Down>' : '<TAB>'
" " inoremap <expr><S-TAB>  pumvisible() ? '\<Up>' : ''

" neocomplete.vim
" ---------------------------------------------------
Plugin 'Shougo/neocomplete.vim'

let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#enable_auto_select = 1 " let neocomplete's completion behavior like AutoComplPop
" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" " YouCompleteMe
" " ---------------------------------------------------
" Plugin 'Valloric/YouCompleteMe'

" " neosnippet.vim
" " ---------------------------------------------------
" Plugin 'Shougo/neosnippet.vim'

" " snipmate.vim
" " ---------------------------------------------------
" Plugin 'msanders/snipmate.vim'

" snipmate-snippets
" " ---------------------------------------------------
" Plugin 'spf13/snipmate-snippets'

" undotree
" ---------------------------------------------------
Plugin 'mbbill/undotree'

nnoremap <leader>ud :UndotreeToggle<CR>

let g:undotree_SetFocusWhenToggle=1
let g:undotree_WindowLayout = 4

" tabular: invoke by <leader>= alignment-character
" ---------------------------------------------------
Plugin 'godlygeek/tabular'

nnoremap <silent> <leader>= :call g:Tabular(1)<CR>
xnoremap <silent> <leader>= :call g:Tabular(0)<CR>
function! g:Tabular(ignore_range) range
    let c = getchar()
    let c = nr2char(c)
    if a:ignore_range == 0
        exec printf('%d,%dTabularize /%s', a:firstline, a:lastline, c)
    else
        exec printf('Tabularize /%s', c)
    endif
endfunction

" vim-easymotion: invoke by <leader><leader> w,b,e,ge,f,F,h,i,j,k,/
" ---------------------------------------------------
Plugin 'Lokaltog/vim-easymotion'

map <leader><leader>/ <Plug>(easymotion-sn)
omap <leader><leader>/ <Plug>(easymotion-tn)
map <leader><leader>j <Plug>(easymotion-j)
map <leader><leader>k <Plug>(easymotion-k)
map <leader><leader>l <Plug>(easymotion-lineforward)
map <leader><leader>h <Plug>(easymotion-linebackward)
let g:EasyMotion_startofline = 0 " keep cursor colum when JK motion

" LargeFile
" ---------------------------------------------------
Plugin 'vim-scripts/LargeFile'

let g:LargeFile= 5 " files >= 5MB will use LargeFile rules

" vim-better-whitespace
" ---------------------------------------------------
Plugin 'ntpeters/vim-better-whitespace'

nnoremap <unique> <leader>sw :StripWhitespace<CR>

" emmet-vim
" ---------------------------------------------------
Plugin 'mattn/emmet-vim'

" make sure emmet only enable in html,css files
let g:user_emmet_install_global = 0
autocmd FileType html,css EmmetInstall

" vim-indent-guides
" ---------------------------------------------------
Plugin 'nathanaelkane/vim-indent-guides'

let g:indent_guides_guide_size = 1

" vim-javascript
" ---------------------------------------------------
Plugin 'pangloss/vim-javascript'

" vim-coffee-script
" ---------------------------------------------------
Plugin 'kchmck/vim-coffee-script'

" vim-css-color
" ---------------------------------------------------
" Plugin 'skammer/vim-css-color'

" vim-css3-syntax
" ---------------------------------------------------
Plugin 'hail2u/vim-css3-syntax'

" vim-jade
" ---------------------------------------------------
Plugin 'digitaltoad/vim-jade'

" vim-less
" ---------------------------------------------------
Plugin 'groenewege/vim-less'

" vim-stylus
" ---------------------------------------------------
Plugin 'wavded/vim-stylus'

" vim-markdown
" ---------------------------------------------------
Plugin 'plasticboy/vim-markdown'

let g:vim_markdown_initial_foldlevel=9999

" vim-jst
" ---------------------------------------------------
Plugin 'briancollins/vim-jst'

" rust.vim
" ---------------------------------------------------
Plugin 'rust-lang/rust.vim'

" vim-go
" ---------------------------------------------------
Plugin 'fatih/vim-go'

let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

au FileType go nmap <leader>r <Plug>(go-run)
au FileType go nmap <leader>b <Plug>(go-build)
au FileType go nmap <leader>t <Plug>(go-test)
au FileType go nmap <leader>c <Plug>(go-coverage)

au FileType go nmap <Leader>ds <Plug>(go-def-split)
au FileType go nmap <Leader>dv <Plug>(go-def-vertical)
au FileType go nmap <Leader>dt <Plug>(go-def-tab)

au FileType go nmap <Leader>gd <Plug>(go-doc)
au FileType go nmap <Leader>gv <Plug>(go-doc-vertical)
au FileType go nmap <Leader>gb <Plug>(go-doc-browser)

au FileType go nmap <Leader>s <Plug>(go-implements)

au FileType go nmap <Leader>i <Plug>(go-info)

au FileType go nmap <Leader>e <Plug>(go-rename)

" vim-hybrid
" ---------------------------------------------------
Plugin 'w0ng/vim-hybrid'

colorscheme hybrid

" unite.vim
" ---------------------------------------------------
Plugin 'Shougo/unite.vim'

nnoremap <leader>bf :<C-u>Unite buffer<CR>
nnoremap <leader>fl :<C-u>Unite file<CR>
nnoremap <leader>fr :<C-u>Unite -start-insert file_rec<CR>

" tagbar
" ---------------------------------------------------
Plugin 'majutsushi/tagbar'

nnoremap <leader>tb :<C-u>TagbarToggle<CR>
