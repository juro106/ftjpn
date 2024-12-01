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

function! s:SetKeyMap(list) abort
    for item in a:list
        let arr = []
        for i in item
            let j = i == '|' ? '\|' : i
            let k = "'" . j . "'"
            call add(arr, k)
        endfor
        let key_list = "[" . join(arr, ",") . "]"
        exe 'nnoremap <silent> ' . g:ftjpn_f . item[0] . ' :<C-u>call ftjpn#Jfmove(' . key_list . ')<CR>'
        exe 'nnoremap <silent> ' . g:ftjpn_F . item[0] . ' :<C-u>call ftjpn#JFmove(' . key_list . ')<CR>'
        exe 'nnoremap <silent> ' . g:ftjpn_t . item[0] . ' :<C-u>call ftjpn#Jtmove(' . key_list . ')<CR>'
        exe 'nnoremap <silent> ' . g:ftjpn_T . item[0] . ' :<C-u>call ftjpn#JTmove(' . key_list . ')<CR>'
        exe 'onoremap <silent><expr> ' . g:ftjpn_f . item[0] . ' ftjpn#Jof(' . key_list . ')'
        exe 'onoremap <silent><expr> ' . g:ftjpn_F . item[0] . ' ftjpn#JoF(' . key_list . ')'
        exe 'onoremap <silent><expr> ' . g:ftjpn_t . item[0] . ' ftjpn#Jot(' . key_list . ')'
        exe 'onoremap <silent><expr> ' . g:ftjpn_T . item[0] . ' ftjpn#JoT(' . key_list . ')'
        exe 'xnoremap <silent><expr> ' . g:ftjpn_f . item[0] . ' ftjpn#Jof(' . key_list . ')'
        exe 'xnoremap <silent><expr> ' . g:ftjpn_F . item[0] . ' ftjpn#JoF(' . key_list . ')'
        exe 'xnoremap <silent><expr> ' . g:ftjpn_t . item[0] . ' ftjpn#Jot(' . key_list . ')'
        exe 'xnoremap <silent><expr> ' . g:ftjpn_T . item[0] . ' ftjpn#JoT(' . key_list . ')'
    endfor
endfunction
call <SID>SetKeyMap(key_list)

let &cpo = s:save_cpo
unlet s:save_cpo
