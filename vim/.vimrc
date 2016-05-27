" Vim settings

"---- General settings and fail safes-----------------------------------
set nocompatible				" Not vi compatible
set tabstop=4					" Set the tab size to 4
set shiftwidth=4				" Set indent size
set nu							" Turn on line numbers
set showcmd						" Show (partial) command in status line.
set showmatch					" Show matching brackets.
set ignorecase					" Do case insensitive matching
set smartcase					" Case-sensitive when uppercase chars included
set hlsearch        			" Highlight search terms found
set incsearch					" Find as you type
set nobackup					" No backup files (file~)
set nowritebackup				" 
set noswapfile					" No .swp files
set laststatus=2				" always have a status bar at the bottom.
set mouse=a						" Allow mouse where possible
set ttymouse=xterm2				" Enable the mouse through GNU screen
set background=dark				" Default. Background may be overridden is OS settings
set showtabline=2				" Always show the tab line
set guioptions-=T				" Turn off toolbars, but leave on menues
set shortmess=oI				" Disable intro messages, messages overwrite each other
set bs=indent,eol,start		 	" Backspace over everything in insert mode
set noshowmode					" Hide the default mode text (INSERT below the statusline)


"---- Path and wildmenu ------------------------------------------------
" search current dir, followed by PWD
set path=.,,

set wildmenu

" longest substr match; list all matches in wildmenu
set wildmode=longest:full,full
"set wildmode=longest:list,full

" ignore patterns for wildmenu
set wildignore+=*.min.*,__pycache__,*.pyc


"---- OS Specific options ----------------------------------------------
if has('unix')
	"Unix general settings
	highlight LineNr guifg=red guibg=grey90
	set t_Co=256							" Force 256 colours in GNU Screen
	colorscheme ir_black_plus
endif


"---- Mappings ---------------------------------------------------------
"NOTE: 	To see what a key sends use ctrl+k then keystroke while in insert mode

" use semi-colon for cmdline mode
:nmap ; :

" leader is spacebar
let mapleader = "\<Space>"

" short timeout after leader pressed
set timeoutlen=400

" Map a key for some spell checking
map <F7> :setlocal spell! spelllang=en_gb<cr>
imap <F7> <ESC><F7>

" Shortcut tab next/previous
map <leader>[ :tabprev<CR>
map <leader>] :tabnext<CR>
map <leader>1 1gt
map <leader>2 2gt
map <leader>3 3gt
map <leader>4 4gt
map <leader>5 5gt
map <leader>6 6gt
map <leader>7 7gt
map <leader>8 8gt

" Easy insert newline
noremap 0 o<ESC>

" Mapping to reload gunicorn
map <C-G>r<CR> :!kill -HUP `cat /tmp/gunicorn.pid`<CR><CR>

" Make standard "gf" open in a new tab
noremap gf <C-w>gF

" NERDTree visibility
:nmap \e :NERDTreeToggle<CR>

" disable Ex mode
nnoremap Q <nop>

" Allow saving of files as sudo http://stackoverflow.com/a/7078429/425050
cmap w!! w !sudo tee > /dev/null %


"---- Code completion options ------------------------------------------
" The same trick is needed to get ctrl+space to autocomplete in all environments
if has("gui_running")
	imap <C-Space> <C-x><C-o>
else
	imap <nul> <C-x><C-o>
endif

" This makes AC easier to use
set completeopt=longest,menuone,preview

" Auto close the preview window when selected or move
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

" highlight .wsgi files as python
au BufNewFile,BufRead *.wsgi	setf python

" highlight Arduino
autocmd! BufNewFile,BufRead *.ino setlocal ft=arduino


"---- Vundle ------------------------------------------------------------
filetype off                   " required!
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'

" original repos on github
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'scrooloose/syntastic'
Plugin 'saltstack/salt-vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-markdown'
Plugin 'elzr/vim-json'
Plugin 'fatih/vim-go'
Plugin 'bkad/vim-terraform'
Plugin 'chase/vim-ansible-yaml'
Plugin 'editorconfig/editorconfig-vim'

call vundle#end()            " required
filetype plugin indent on    " required


"---- Code folding ------------------------------------------------------
" Map to comma
nnoremap , za

set foldmethod=indent
set foldlevel=99
set foldnestmax=1

Plugin 'tmhedberg/SimpylFold'

let g:SimpylFold_docstring_preview = 1


"---- Syntastic -------------------------------------------------------
let g:syntastic_python_checkers = ['pyflakes', 'python']
let g:syntastic_python_pyflakes_exe = 'python3 -m pyflakes'
let g:syntastic_python_flake8_args='--ignore=E501'
let g:syntastic_mode_map = { 'mode': 'active',
						   \ 'active_filetypes': [],
						   \ 'passive_filetypes': ['java', 'sass', 'scss'] }


"---- File type options ------------------------------------------------
" Individual filetype settings in ~/.vim/ftplugin/<type>.vim
" These come after any Vundle highlight plugins
syntax enable					" General file type syntax highlighting

" Small changes that don't warrent an ftplugin file of their own
au filetype help :se nonu		" turn off line numbers for help

" Java
autocmd FileType java setlocal shiftwidth=2 tabstop=2
" HTML
autocmd FileType html setlocal shiftwidth=2 tabstop=2
" XHTML
autocmd FileType xhtml setlocal shiftwidth=2 tabstop=2
" HTML/Jinja templates
autocmd FileType htmldjango setlocal shiftwidth=2 tabstop=2
" Markdown
autocmd FileType markdown setlocal shiftwidth=2 tabstop=2 expandtab
" YAML
autocmd FileType yaml setlocal shiftwidth=2 tabstop=2 expandtab
" JSON
autocmd FileType json setlocal shiftwidth=2 tabstop=2 cole=0
" gitrebase
autocmd FileType gitrebase set modelines=0
" Terraform
autocmd FileType terraform setlocal shiftwidth=2 tabstop=2 cole=0
" Makefile
autocmd FileType make setlocal noexpandtab shiftwidth=4 softtabstop=0


"---- GitGutter -------------------------------------------------------
" prevent gitgutter raising Vim alerts
let g:gitgutter_realtime = 0

" colour scheme
highlight GitGutterAdd ctermbg=black
highlight GitGutterChange ctermbg=black
highlight GitGutterDelete ctermbg=black
highlight GitGutterChangeDelete ctermbg=black

highlight GitGutterAdd ctermfg=green
highlight GitGutterChange ctermfg=yellow
highlight GitGutterDelete ctermfg=red
highlight GitGutterChangeDelete ctermfg=yellow


"---- Airline ---------------------------------------------------------
" airline theme
let g:airline_theme='powerlineish'

" enable airline tab bar
let g:airline#extensions#tabline#enabled = 1
" don't show the close button
"let g:airline#extensions#tabline#show_close_button = 0
" fancy unicode close symbol
let g:airline#extensions#tabline#close_symbol = '✘'
" display tab number in tab bar
let g:airline#extensions#tabline#tab_nr_type = 1
" never show buffers in tabline
let g:airline#extensions#tabline#show_buffers = 0
" powerline symbols in tabline
let g:airline#extensions#tabline#left_sep = '⮀'
let g:airline#extensions#tabline#left_alt_sep = '⮁'
let g:airline#extensions#tabline#right_sep = '⮂'
let g:airline#extensions#tabline#right_alt_sep = '⮃'

" disable airline whitespace checker
let g:airline#extensions#whitespace#enabled = 0
" whitespace algo allows tabs followed by spaces
let g:airline#extensions#whitespace#mixed_indent_algo = 1

" old vim-powerline symbols
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_left_sep = '⮀'
let g:airline_left_alt_sep = '⮁'
let g:airline_right_sep = '⮂'
let g:airline_right_alt_sep = '⮃'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.readonly = '⭤'
let g:airline_symbols.linenr = ''

let g:airline#extensions#branch#enabled = 0
