" mark up column 81 to indicate E501 max line length
set colorcolumn=81
highlight ColorColumn ctermbg=8

" setup macros to insert common debug statements
let @i = 'Oimport ipdb; ipdb.set_trace()'
let @p = 'Oimport pdb; pdb.set_trace()'
let @r = 'Ofrom celery.contrib import rdb; rdb.set_trace()'
