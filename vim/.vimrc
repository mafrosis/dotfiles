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
set shortmess=I					" Turn off the intro message
set bs=indent,eol,start     	" Backspace over everything in insert mode


"---- OS Specific options ----------------------------------------------
if has('unix')
	"Unix general settings
	highlight LineNr guifg=red guibg=grey90
	set t_Co=256							" Force 256 colours in GNU Screen
	colorscheme ir_black_plus
endif


"---- File type options ------------------------------------------------
" Individual filetype settings in ~/.vim/ftplugin/<type>.vim
syntax enable					" General file type syntax highlighting

" Small changes that don't warrent an ftplugin file of their own
au filetype help :se nonu		" turn off line numbers for help


"---- Mappings ---------------------------------------------------------
"NOTE: 	To see what a key sends use ctrl+k then keystroke while in insert mode

" Map a key for some spell checking
map <F7> :setlocal spell! spelllang=en_gb<cr>
imap <F7> <ESC><F7>

" Shortcut tab next/previous
map <C-P>[ :tabprev<CR>
map <C-P>] :tabnext<CR>
map <C-left> :tabprev<CR>
map <C-right> :tabnext<CR>

" Easy insert newline
noremap 0 o<ESC>

" Map that useless Macbook key to ESC
map § <ESC>
imap § <ESC>

" Mapping to reload gunicorn
map <C-G>r<CR> :!kill -HUP `cat /tmp/gunicorn.pid`<CR><CR>

" Make standard "gf" open in a new tab
noremap gf <C-w>gF

" NERDTree visibility
:nmap \e :NERDTreeToggle<CR>


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

" Map code folding to spacebar
nnoremap <space> za


"---- Code folding ------------------------------------------------------
set foldmethod=indent
set foldlevel=99


"---- Vundle ------------------------------------------------------------
filetype off                   " required!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
Bundle 'gmarik/vundle'

" original repos on github
Bundle 'tpope/vim-fugitive'
Bundle 'Lokaltog/powerline'
Bundle 'scrooloose/syntastic'
Bundle 'saltstack/salt-vim'
Bundle 'airblade/vim-gitgutter'
Bundle 'tpope/vim-markdown'

" vim-scripts repos
"Bundle 'L9'
"Bundle 'FuzzyFinder'

" non github repos
"Bundle 'git://git.wincent.com/command-t.git'

filetype plugin indent on     " required!


"---- Syntastic -------------------------------------------------------
let g:syntastic_python_flake8_args='--ignore=E501'
let g:syntastic_mode_map = { 'mode': 'active',
						   \ 'active_filetypes': [],
						   \ 'passive_filetypes': ['java'] }

"---- Powerline -------------------------------------------------------
set rtp+=~/.vim/bundle/powerline/powerline/bindings/vim
let g:Powerline_symbols = 'fancy'

set noshowmode " Hide the default mode text (e.g. -- INSERT -- below the statusline)
