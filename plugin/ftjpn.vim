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

"if !exists('g:ftjpn_key_list')
"let g:ftjpn_key_list = [
"    \ ['.', '。', '．'],
"    \ [',', '、', '，'],
"    \ ]
"endif

function! s:SetKeyMap(list) abort
    for item in a:list
        let arr = []
        for i in item
            let j = "'" . i . "'"
            call add(arr, j)
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
call <SID>SetKeyMap(g:ftjpn_key_list)

let &cpo = s:save_cpo
unlet s:save_cpo
