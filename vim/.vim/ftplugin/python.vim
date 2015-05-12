" mark up column 81 to indicate E501 max line length
set colorcolumn=81
highlight ColorColumn ctermbg=8

" set foldnextmax=2 if file contains a class definition
func! s:PythonFoldNestMax()
	if search('^class ', 'n') > 0
		set foldnestmax=2
	else
		set foldnestmax=1
	endif
endfunc

" call function after buffer filled
autocmd BufReadPost,FileReadPost,BufWinEnter * call s:PythonFoldNestMax()

" setup command :PythonFoldNestMax
command! -bar PythonFoldNestMax  call s:PythonFoldNestMax()

" setup macros to insert common debug statements
let @i = 'Oimport ipdb; ipdb.set_trace()'
let @p = 'Oimport pdb; pdb.set_trace()'
let @r = 'Ofrom celery.contrib import rdb; rdb.set_trace()'
