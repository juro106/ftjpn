if exists('g:loaded_ftjpn')
    finish
endif
let g:loaded_ftjpn = 1

let s:save_cpo = &cpo
set cpo&vim

let key_list = []

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
    let arr = []
    for i in list
        let j = i == '|' ? '\|' : i
        let k = "'" . j . "'"
        call add(arr, k)
    endfor

    let keys = "[" . join(arr, ",") . "]"

    exe  'nnoremap <silent> f' . key . ' :<C-u>call ftjpn#Forward_N( "f", ' . keys . ')<CR>'
    exe  'nnoremap <silent> t' . key . ' :<C-u>call ftjpn#Forward_N( "t", ' . keys . ')<CR>'
    exe  'nnoremap <silent> F' . key . ' :<C-u>call ftjpn#Backward_N("F", ' . keys . ')<CR>'
    exe  'nnoremap <silent> T' . key . ' :<C-u>call ftjpn#Backward_N("T", ' . keys . ')<CR>'
    exe  'onoremap <silent><expr> f' . key . ' ftjpn#Forward_O("f", ' . keys . ')'
    exe  'onoremap <silent><expr> t' . key . ' ftjpn#Forward_O("t", ' . keys . ')'
    exe  'onoremap <silent><expr> F' . key . ' ftjpn#Backward_O("F", ' . keys . ')'
    exe  'onoremap <silent><expr> T' . key . ' ftjpn#Backward_O("T", ' . keys . ')'
    exe  'xnoremap <silent><expr> f' . key . ' ftjpn#Forward_O("f", ' . keys . ')'
    exe  'xnoremap <silent><expr> t' . key . ' ftjpn#Forward_O("t", ' . keys . ')'
    exe  'xnoremap <silent><expr> F' . key . ' ftjpn#Backward_O("F", ' . keys . ')'
    exe  'xnoremap <silent><expr> T' . key . ' ftjpn#Backward_O("T", ' . keys . ')'
endfor

let &cpo = s:save_cpo
unlet s:save_cpo
