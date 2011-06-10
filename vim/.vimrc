" Vim settings
" 16/02/2009


"---- General settings and fail safes-----------------------------------
set nocompatible				" Not vi compatible
set tabstop=4					" Set the tab size to 4
set shiftwidth=4				" Set indent size
set nu							" Turn on line numbers
set showcmd						" Show (partial) command in status line.
set showmatch					" Show matching brackets.
set ignorecase					" Do case insensitive matching
set hlsearch        			" Highlight search terms found
set incsearch					" Find as you type
set nobackup					" No backup files (file~)
set laststatus=2				" always have a status bar at the bottom.
set mouse=a						" Allow mouse where possible
set ttymouse=xterm2				" Enable the mouse through GNU screen
set background=dark				" Default. Background may be overridden is OS settings
set showtabline=2				" Always show the tab line
set guioptions-=T				" Turn off toolbars, but leave on menues
set shortmess=I					" Turn off the intro message


"---- OS Specific options ----------------------------------------------
if has('unix')
	"Unix general settings
	highlight LineNr guifg=red guibg=grey90
	set t_Co=256							" Force 256 colours in GNU Screen
	colorscheme ir_black_plus
	
	if has('gui_running')
		"Unix windowed environment
		set guifont=Bitstream\ Vera\ Sans\ Mono\ 12
		set columns=124 lines =38
	else
		"Unix command line
		set background=dark						" Dark background for shell
	endif
endif

if has('win32')
	"Windows general settings. TODO: split these to gui and cmd
	source $VIMRUNTIME/vimrc_example.vim
	source $VIMRUNTIME/mswin.vim
	behave mswin
	set diffexpr=WindowsMyDiff()
	set guifont=Bitstream\ Vera\ Sans\ Mono:h10:cDEFAULT 
	winpos 120 20
	set lines=55
	set columns=130
	set directory=c:\temp,c:\tmp,.				" Hide the temp files somewhere else (prefer c:\temp). Resolve in order
	set	clipboard=unnamed 						" For yanking into the windows clip board
	colorscheme ir_black_plus
	set nobackup								" On windows this needs to be restated to work. TODO: Look into this.
endif 


"---- File type options ------------------------------------------------
" Individual filetype settings in ~/.vim/ftplugin/<type>.vim
syntax enable					" General file type syntax highlighting
filetype plugin on				" Use filetype plugins
filetype indent on				" Filetype indenting

" Small changes that don't warrent an ftplugin file of their own
au filetype help :se nonu		" turn off line numbers for help


"---- Mappings ---------------------------------------------------------
"NOTE: 	To see what a key sends use ctrl+k then keystroke while in 
"		insert mode

"Map a key for some spell checking
map <F7> :setlocal spell! spelllang=en_gb<cr>
imap <F7> <ESC>:setlocal spell! spelllang=en_gb<cr>

" Make standard "gf" open in a new tab
noremap gf <C-w>gF

" Easy tab movement (If statement handles problems with Putty and C-Left/C-Right)
if has("gui_running")
	" Problem with KDE terminal?
	map <C-left> : tabprev<CR>
	imap <C-left> <esc> : tabprev <cr>
	map <C-right> : tabnext<CR>
	imap <C-right> <esc> : tabnext <cr>
else
	map <Esc>[D :tabprev<CR>
	imap <Esc>[D <Esc> :tabprev<CR>
	map <Esc>[C :tabnext<CR>
	imap <Esc>[C <Esc> :tabnext<CR>
endif

" TODO: Key words open in a new tab

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


"---- Functions --------------------------------------------------------
function WindowsMyDiff()
	let opt = '-a --binary '
	if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
	if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
	let arg1 = v:fname_in
	if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
	let arg2 = v:fname_new
	if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
	let arg3 = v:fname_out
	if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
	if &sh =~ '\<cmd'
		silent execute '!""C:\Program Files\Vim\vim72\diff" ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . '"'
	else
		silent execute '!C:\Program" Files\Vim\vim72\diff" ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
	endif
endfunction


