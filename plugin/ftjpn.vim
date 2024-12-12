if exists('g:loaded_ftjpn')
    finish
endif
let g:loaded_ftjpn = 1

let s:save_cpo = &cpo
set cpo&vim

call ftjpn#async_setup()

let &cpo = s:save_cpo
unlet s:save_cpo
