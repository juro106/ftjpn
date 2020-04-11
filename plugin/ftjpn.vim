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

if !exists('g:ftjpn_key_list')
let g:ftjpn_key_list = [
    \ ['.', '。', '．'],
    \ [',', '、', '，'],
    \ ]
endif

function! s:SetKeyMap(list) abort
    for item in a:list
        let newlist = []
        for i in item
            let newitem = "'" . i . "'"
            call add(newlist, newitem)
        endfor
        let charlist = "[" . join(newlist, ",") . "]"
        exe 'nnoremap <silent> ' . g:ftjpn_f . item[0] . ' :<C-u>call ftjpn#Jfmove(' . charlist . ')<CR>'
        exe 'nnoremap <silent> ' . g:ftjpn_F . item[0] . ' :<C-u>call ftjpn#JFmove(' . charlist . ')<CR>'
        exe 'nnoremap <silent> ' . g:ftjpn_t . item[0] . ' :<C-u>call ftjpn#Jtmove(' . charlist . ')<CR>'
        exe 'nnoremap <silent> ' . g:ftjpn_T . item[0] . ' :<C-u>call ftjpn#JTmove(' . charlist . ')<CR>'
        exe 'onoremap <silent><expr> ' . g:ftjpn_f . item[0] . ' ftjpn#Jof(' . charlist . ')'
        exe 'onoremap <silent><expr> ' . g:ftjpn_F . item[0] . ' ftjpn#JoF(' . charlist . ')'
        exe 'onoremap <silent><expr> ' . g:ftjpn_t . item[0] . ' ftjpn#Jot(' . charlist . ')'
        exe 'onoremap <silent><expr> ' . g:ftjpn_T . item[0] . ' ftjpn#JoT(' . charlist . ')'
        exe 'xnoremap <silent><expr> ' . g:ftjpn_f . item[0] . ' ftjpn#Jof(' . charlist . ')'
        exe 'xnoremap <silent><expr> ' . g:ftjpn_F . item[0] . ' ftjpn#JoF(' . charlist . ')'
        exe 'xnoremap <silent><expr> ' . g:ftjpn_t . item[0] . ' ftjpn#Jot(' . charlist . ')'
        exe 'xnoremap <silent><expr> ' . g:ftjpn_T . item[0] . ' ftjpn#JoT(' . charlist . ')'
    endfor
endfunction
call <SID>SetKeyMap(g:ftjpn_key_list)

let &cpo = s:save_cpo
unlet s:save_cpo
