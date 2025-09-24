if exists('g:loaded_ftjpn')
    finish
endif
let g:loaded_ftjpn = 1

let s:save_cpo = &cpo
set cpo&vim

if type(g:ftjpn_key_list) ==# 3 " list
    let key_list = g:ftjpn_key_list
elseif type(g:ftjpn_key_list) ==# 4 " dictionary
    let key_list = []
    for key in keys(g:ftjpn_key_list)
        let cur_list = g:ftjpn_key_list[key]
        let cur_key = cur_list[0]
        if cur_key == key
            call add(key_list, cur_list)
        else
            call add(key_list, [key] + cur_list)
        endif
    endfor
else
    let key_list = [['.'], [',']]
endif

for list in key_list
    let key = list[0]
    let keys = escape(string(list), "|")

    exe  'nnoremap <silent><expr> f' . key . ' ftjpn#Forward("f", ' . keys . ')'
    exe  'nnoremap <silent><expr> t' . key . ' ftjpn#Forward("t", ' . keys . ')'
    exe  'nnoremap <silent><expr> F' . key . ' ftjpn#Backward("F", ' . keys . ')'
    exe  'nnoremap <silent><expr> T' . key . ' ftjpn#Backward("T", ' . keys . ')'
    exe  'onoremap <silent><expr> f' . key . ' ftjpn#Forward("f", ' . keys . ')'
    exe  'onoremap <silent><expr> t' . key . ' ftjpn#Forward("t", ' . keys . ')'
    exe  'onoremap <silent><expr> F' . key . ' ftjpn#Backward("F", ' . keys . ')'
    exe  'onoremap <silent><expr> T' . key . ' ftjpn#Backward("T", ' . keys . ')'
    exe  'xnoremap <silent><expr> f' . key . ' ftjpn#Forward("f", ' . keys . ')'
    exe  'xnoremap <silent><expr> t' . key . ' ftjpn#Forward("t", ' . keys . ')'
    exe  'xnoremap <silent><expr> F' . key . ' ftjpn#Backward("F", ' . keys . ')'
    exe  'xnoremap <silent><expr> T' . key . ' ftjpn#Backward("T", ' . keys . ')'
endfor

let &cpo = s:save_cpo
unlet s:save_cpo
