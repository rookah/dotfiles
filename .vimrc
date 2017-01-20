" VUNDLE ; :PluginInstall, :PluginList, :PluginSearch [...], :PluginClean
set nocompatible
filetype off
set rtp+=~/.vim/bundle/vundle
call vundle#begin() 
Plugin 'gmarik/vundle'

" General plugins {{{
Plugin 'scrooloose/nerdtree' " Directory tree <C-n>
Plugin 'scrooloose/syntastic' " Code correction
Plugin 'majutsushi/tagbar' " Source code tags
 
Plugin 'Valloric/YouCompleteMe' " Auto-completion
Plugin 'rdnetto/YCM-Generator' 
 
Plugin 'yegappan/grep' " Vim grep
Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-session' " Session management for Vim
Plugin 'xolox/vim-notes' " Taking notes in Vim
 
" Plugin 'Yggdroot/indentLine' " Indent line
Plugin 'Raimondi/delimitMate' " Automatic closing of quotes, brackets etc
Plugin 'luochen1990/rainbow' " Rainbow parenthesis
 
Plugin 'bling/vim-airline' " Status/Tabline

" C/Cpp {
Plugin 'vim-jp/cpp-vim' " C/Cpp syntax files
Plugin 'a.vim' " :A to switch between .c and .h
Plugin 'drmikehenry/vim-headerguard' " Automatically adds headerguards to C/Cpp .h files
Plugin 'octol/vim-cpp-enhanced-highlight' " Enhanced highlighting
" }

" Racket {
Plugin 'wlangstroth/vim-racket' " Simple Racket syntax file
" }

" }}}

call vundle#end()

filetype plugin indent on
syntax on

" CONFIG {{
set viminfo+=n~/.vim/viminfo
set mouse=a " use mouse for all moves

set t_Co=256 " use terminal colors

set encoding=utf-8 " set encoding protocol

set backspace=indent,eol,start

set hidden
set number " display line number
set nuw=1 " min number of columns to display line
set title " display title+specifications
set confirm " display dialogue when exiting without saving
set ignorecase " ignore case
set smartcase " override ignorecase when searching for case-specific patterns

set incsearch " progressive search
set hlsearch " search highlighting

set noerrorbells " no beep/flash for error messages
set laststatus=2 " 0, 1, 2 (view doc)
set novisualbell " no flash
set cmdheight=1 " size of cmd line (default = 1)

set cursorline " easily spot the cursor
set lazyredraw " redraw screen with :redraw
set wrap " wraps text
set linebreak " wraps at the end of the word instead of character

set cindent " automatic C program indenting
set cinoptions=g0
" set list lcs=tab:\¦\ 
set expandtab
set softtabstop=4
set tabstop=4
set shiftwidth=4 

set timeoutlen=1000 ttimeoutlen=0
set tabpagemax=100 " maximum number of tabs limit


" Vimtex
let g:tvimtex_enabled = 1
let g:vimtex_view_general_viewer = "zathura"
set grepprg=grep\ -nh\ $*
let g:tex_flavor = "latex"

" }}

" Mapping
"map <C-h> :HeaderguardAdd<CR>
map <silent> <F3> :TagbarToggle<CR>
map <silent> <F4> :ccl<CR>
map <silent> <F5> :make! \| :copen<CR>

" Map ctrl + w to save current buffer if it has been modified
" noremap <silent><C-w> :update<CR>

" gf shortcut
nnoremap gf <c-w>gf

" Map shift + w to write all buffers
noremap <silent><S-w> :wa<CR>

" Switch tabs with s+h/s+l
nnoremap <silent><S-h> :tabp<CR>
nnoremap <silent><S-l> :tabn<CR>

" Switch splits with Ctrl + hjkl
nnoremap <silent><C-h> :wincmd h<CR>
nnoremap <silent><C-j> :wincmd k<CR>
nnoremap <silent><C-k> :wincmd j<CR>
nnoremap <silent><C-l> :wincmd l<CR>

" Clear search
nmap <silent><C-b> :silent noh<CR>

" colemak
noremap j gk
noremap J K
noremap k gj
noremap K J

" YouCompleteMe
let g:ycm_global_ycm_extra_conf = "~/.vim/.ycm_extra_conf.py"

let g:ycm_python_binary_path = '/usr/bin/python2.7'
let g:ycm_server_python_interpreter = '/usr/bin/python2.7'
set completeopt-=preview
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_extra_conf_globlist = ['~/Programming/*']
let g:ycm_register_as_syntastic_checker = 0
let g:ycm_show_diagnostics_ui = 0


" Syntastic
let g:syntastic_stl_format ='' 
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_enable_highlighting = 1
let g:syntastic_c_auto_refresh_includes = 1
let g:syntastic_cpp_compiler_options = '-std=c++11'
let g:syntastic_cpp_no_include_search = 1
let g:syntastic_enable_racket_racket_checker = 1


" Set theme
let g:airline_theme = 'powerlineish'
let g:airline_powerline_fonts = 1


" Rainbow
let g:rainbow_active=1
let g:rainbow_conf = {
            \   'guifgs': ['#94aad1', '#8ab4be', '#edc472', '#c98dad'],
            \   'ctermfgs': ['12', '14', '11', '13'],
            \}

"indentLine
" autocmd BufRead * :IndentLinesEnable
" let g:indentLines_loaded = 1
" let g:indentLines_enabled = 1
" let g:indentLine_char = '|'
" let g:indentLine_bufNameExclude = [ 'NERD_tree*' ]
" let g:indentLine_noConcealCursor = 1
" let g:indentLine_color_gui = '#222222'
" let g:indentLine_color_term = 236
" let g:indentLine_color_tty = 236


" NERDTree
let g:NERDTreeDirArrows=0
map <C-n> :NERDTreeToggle<CR>


" Sessions
set sessionoptions-=help
set sessionoptions-=options
set sessionoptions+=resize
set sessionoptions+=tabpages
let g:session_autosave = 'yes'
let g:session_autoload = 'no'
let g:session_autosave_periodic = 0
let g:session_default_to_last = 1
let g:session_persist_globals = [ '&expandtab' ]


" Save cursor pos {
augroup resCur
	autocmd!
	autocmd BufReadPost * call setpos(".", getpos("'\""))
augroup END


" Keep indent after blank line
" inoremap <CR> <CR>x<BS>
" nnoremap o ox<BS>
" nnoremap O Ox<BS>


" Remove autocommenting
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o


" Adds a dummy sign
" augroup mine
" 	au BufWinEnter * sign define mysign
" 	au BufWinEnter * exe "sign place 1337 line=1 name=mysign buffer=" . bufnr('%')
" augroup end


colorscheme YumyW


" GVim {{{
set guioptions=+a
set guifont=tewi2a
set guiheadroom=0
set guicursor=n-v-c:block-Cursor
set guicursor+=i:block-Cursor
set guicursor+=n-v-c:blinkon0
set guicursor+=i:blinkon0
" }}}

