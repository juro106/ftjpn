scriptencoding utf-8

if exists('g:loaded_ftjpn')
    finish
endif

let g:loaded_ftjpn = 1

let s:save_cpo = &cpo
set cpo&vim

if !get(g:, 'ftjpn_no_defalut_key_mappings', 0)
    let g:ftjpn_f = 'f'
    let g:ftjpn_F = 'F'
    let g:ftjpn_t = 't'
    let g:ftjpn_T = 'T'
endif

let key_list = []

if type(g:ftjpn_key_list) ==# 3 " list
    let key_list = g:ftjpn_key_list
elseif type(g:ftjpn_key_list) ==# 4 " dictionary
    let new_list = []
    for key in keys(g:ftjpn_key_list)
        let cur_list = g:ftjpn_key_list[key]
        if cur_list[0] == key
            call add(new_list, cur_list)
        else
            call add(new_list, [key] + cur_list)
        endif
    endfor
    let key_list = new_list
else
    let key_list = [
       \ ['.'],
       \ [','],
       \ ]
endif

function! s:SetKeyMap(nested_list) abort
    for list in a:nested_list
        let arr = []
        for i in list
            let j = i == '|' ? '\|' : i
            let k = "'" . j . "'"
            call add(arr, k)
        endfor
        let keys = "[" . join(arr, ",") . "]"
        exe 'nnoremap <silent> ' . g:ftjpn_f . list[0] . ' :<C-u>call ftjpn#Jfmove(' . keys . ')<CR>'
        exe 'nnoremap <silent> ' . g:ftjpn_F . list[0] . ' :<C-u>call ftjpn#JFmove(' . keys . ')<CR>'
        exe 'nnoremap <silent> ' . g:ftjpn_t . list[0] . ' :<C-u>call ftjpn#Jtmove(' . keys . ')<CR>'
        exe 'nnoremap <silent> ' . g:ftjpn_T . list[0] . ' :<C-u>call ftjpn#JTmove(' . keys . ')<CR>'
        exe 'onoremap <silent><expr> ' . g:ftjpn_f . list[0] . ' ftjpn#Jof(' . keys . ')'
        exe 'onoremap <silent><expr> ' . g:ftjpn_F . list[0] . ' ftjpn#JoF(' . keys . ')'
        exe 'onoremap <silent><expr> ' . g:ftjpn_t . list[0] . ' ftjpn#Jot(' . keys . ')'
        exe 'onoremap <silent><expr> ' . g:ftjpn_T . list[0] . ' ftjpn#JoT(' . keys . ')'
        exe 'xnoremap <silent><expr> ' . g:ftjpn_f . list[0] . ' ftjpn#Jof(' . keys . ')'
        exe 'xnoremap <silent><expr> ' . g:ftjpn_F . list[0] . ' ftjpn#JoF(' . keys . ')'
        exe 'xnoremap <silent><expr> ' . g:ftjpn_t . list[0] . ' ftjpn#Jot(' . keys . ')'
        exe 'xnoremap <silent><expr> ' . g:ftjpn_T . list[0] . ' ftjpn#JoT(' . keys . ')'
    endfor
endfunction
call <SID>SetKeyMap(key_list)

let &cpo = s:save_cpo
unlet s:save_cpo
