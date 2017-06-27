" mark up column 101 to long lines
set colorcolumn=101
highlight ColorColumn ctermbg=8

" setup macros to insert common debug statements
let @i = 'Oimport ipdb; ipdb.set_trace()'
let @p = 'Oimport pdb; pdb.set_trace()'
let @r = 'Ofrom celery.contrib import rdb; rdb.set_trace()'
