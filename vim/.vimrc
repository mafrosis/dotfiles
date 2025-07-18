" Vim settings

"---- General settings and fail safes-----------------------------------
set nocompatible				" Not vi compatible
set modelines=1					" Ensure modelines work
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
set background=dark				" Default. Background may be overridden is OS settings
set showtabline=2				" Always show the tab line
set guioptions-=T				" Turn off toolbars, but leave on menues
set shortmess=oI				" Disable intro messages, messages overwrite each other
set bs=indent,eol,start		 	" Backspace over everything in insert mode
set noshowmode					" Hide the default mode text (INSERT below the statusline)

" Persistent undo
set undodir=~/.vim-undo
set undofile

" https://superuser.com/a/656062
if has("mouse_sgr")
	set ttymouse=sgr				" Modern mouse control chars
else
	set ttymouse=xterm2				" Enable the mouse through GNU screen
end

"---- Path and wildmenu ------------------------------------------------
" search current dir, followed by PWD
set path=.,,

set wildmenu

" longest substr match; list all matches in wildmenu
set wildmode=longest:full,full

" ignore patterns for wildmenu
set wildignore+=*.min.*,__pycache__,*.pyc

" theme
colorscheme mafro
let g:airline_theme='mafro'

" 24-bit colour
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
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

" disable Ex mode
nnoremap Q <nop>

" Allow saving of files as sudo http://stackoverflow.com/a/7078429/425050
cmap w!! w !sudo tee > /dev/null %


"---- Code completion options -----------------------------------------
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


"---- Vundle ----------------------------------------------------------
filetype off                   " required!
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'

" original repos on github
Plugin 'itchyny/lightline.vim'
Plugin 'maximbaz/lightline-ale'
Plugin 'w0rp/ale'
Plugin 'saltstack/salt-vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-markdown'
Plugin 'elzr/vim-json'
Plugin 'fatih/vim-go'
Plugin 'hashivim/vim-terraform'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'ekalinin/Dockerfile.vim'
Bundle 'isobit/vim-caddyfile'
Bundle 'vim-python/python-syntax'
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
Plugin 'lifepillar/pgsql.vim.git'
Plugin 'itspriddle/vim-shellcheck'
Plugin 'davidbeckingsale/writegood.vim'

call vundle#end()            " required
filetype plugin indent on    " required


"---- Code folding ----------------------------------------------------
" Map to comma
nnoremap , za

set foldmethod=indent
set foldlevel=99
set foldnestmax=1

Plugin 'tmhedberg/SimpylFold'

let g:SimpylFold_docstring_preview = 1


"---- Python highlighting ---------------------------------------------

let g:python_highlight_builtins = 1
let g:python_highlight_exceptions = 1
let g:python_highlight_string_formatting = 1
let g:python_highlight_string_format = 1
let g:python_highlight_string_templates = 1
let g:python_highlight_indent_errors = 1
let g:python_highlight_space_errors = 1
let g:python_highlight_func_calls = 0
let g:python_highlight_class_vars = 1
let g:python_highlight_operators = 1
let g:python_highlight_file_headers_as_comments = 1


"---- ALE -------------------------------------------------------------
let g:ale_sign_column_always = 1
let g:ale_linters = {'python': ['ruff'], 'go': ['goimports', 'golint', 'govet']}
let g:ale_fixers = {'python': ['ruff']}

"---- fzf -------------------------------------------------------------
" Shortcut to fzf's GFiles
nnoremap <leader>f :GFiles<Cr>
" Shortcut to use fzf with ag search results
nnoremap <leader>g :Ag<Cr>


"---- File type options -----------------------------------------------
" Individual filetype settings in ~/.vim/ftplugin/<type>.vim
syntax enable
au filetype help :se nonu

" Indentation settings for some types
autocmd FileType java setlocal shiftwidth=2 tabstop=2
autocmd FileType html setlocal shiftwidth=2 tabstop=2
autocmd FileType xhtml setlocal shiftwidth=2 tabstop=2
autocmd FileType htmldjango setlocal shiftwidth=2 tabstop=2
autocmd FileType markdown setlocal shiftwidth=2 tabstop=2 expandtab
autocmd FileType yaml setlocal shiftwidth=2 tabstop=2 expandtab
autocmd FileType json setlocal shiftwidth=2 tabstop=2 cole=0
autocmd FileType gitrebase set modelines=0
autocmd FileType terraform setlocal shiftwidth=2 tabstop=2 cole=0
autocmd FileType make setlocal noexpandtab shiftwidth=4 softtabstop=0

" Filetype overrides
au BufRead,BufNewFile *.tpl set filetype=helm


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


"---- Lightline -------------------------------------------------------
let g:lightline = {
  \ 'component_function': {
  \   'filename': 'LightlineFilename',
  \ },
  \ 'active': {
  \   'left': [
  \     ['mode', 'paste'],
  \     ['readonly', 'filename', 'modified'],
  \   ],
  \   'right': [
  \     ['linter_checking', 'linter_errors', 'linter_warnings', 'linter_infos', 'linter_ok'],
  \     ['percent'],
  \     ['lineinfo'],
  \     ['filetype', 'fileformat', 'fileencoding'],
  \   ],
  \ },
\ }

let g:lightline.component_expand = {
  \ 'linter_checking': 'lightline#ale#checking',
  \ 'linter_infos': 'lightline#ale#infos',
  \ 'linter_warnings': 'lightline#ale#warnings',
  \ 'linter_errors': 'lightline#ale#errors',
  \ 'linter_ok': 'lightline#ale#ok',
\ }

let g:lightline.component_type = {
  \ 'linter_checking': 'right',
  \ 'linter_infos': 'right',
  \ 'linter_warnings': 'warning',
  \ 'linter_errors': 'error',
  \ 'linter_ok': 'right',
\ }

function! LightlineFilename()
  let root = fnamemodify(get(b:, 'git_dir'), ':h')
  let path = expand('%:p')
  if path[:len(root)-1] ==# root
    return path[len(root)+1:]
  endif
  return expand('%')
endfunction


"---- vim-go ----------------------------------------------------------
" don't keep popping up the quickfix window
let g:go_list_type = ""
