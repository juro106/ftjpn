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
        let cur_key = cur_list[0]
        if cur_key == key
            call add(new_list, cur_list)
        else
            call add(new_list, [key] + cur_list)
        endif
    endfor
    let key_list = new_list
else
    let key_list = [['.'], [',']]
endif

let cmds = []
for list in key_list
    let key = list[0]
    let arr = []
    for i in list
        let j = i == '|' ? '\|' : i
        let k = "'" . j . "'"
        call add(arr, k)
    endfor

    let keys = "[" . join(arr, ",") . "]"

    call add(cmds, 'nnoremap <silent> ' . g:ftjpn_f . key . ' :<C-u>call ftjpn#Forward_N("' . g:ftjpn_f . '",' . keys . ')<CR>')
    call add(cmds, 'nnoremap <silent> ' . g:ftjpn_t . key . ' :<C-u>call ftjpn#Forward_N("' . g:ftjpn_t . '",' . keys . ')<CR>')
    call add(cmds, 'nnoremap <silent> ' . g:ftjpn_F . key . ' :<C-u>call ftjpn#Backward_N("' . g:ftjpn_F . '",' . keys . ')<CR>')
    call add(cmds, 'nnoremap <silent> ' . g:ftjpn_T . key . ' :<C-u>call ftjpn#Backward_N("' . g:ftjpn_T . '",' . keys . ')<CR>')
    call add(cmds, 'onoremap <silent><expr> ' . g:ftjpn_f . key . ' ftjpn#Forward_O("' . g:ftjpn_f . '",' . keys . ')<CR>')
    call add(cmds, 'onoremap <silent><expr> ' . g:ftjpn_t . key . ' ftjpn#Forward_O("' . g:ftjpn_t . '",' . keys . ')<CR>')
    call add(cmds, 'onoremap <silent><expr> ' . g:ftjpn_F . key . ' ftjpn#Backward_O("' . g:ftjpn_F . '",' . keys . ')<CR>')
    call add(cmds, 'onoremap <silent><expr> ' . g:ftjpn_T . key . ' ftjpn#Backward_O("' . g:ftjpn_T . '",' . keys . ')<CR>')
    call add(cmds, 'xnoremap <silent><expr> ' . g:ftjpn_f . key . ' ftjpn#Forward_O("' . g:ftjpn_f . '",' . keys . ')<CR>')
    call add(cmds, 'xnoremap <silent><expr> ' . g:ftjpn_t . key . ' ftjpn#Forward_O("' . g:ftjpn_t . '",' . keys . ')<CR>')
    call add(cmds, 'xnoremap <silent><expr> ' . g:ftjpn_F . key . ' ftjpn#Backward_O("' . g:ftjpn_F . '",' . keys . ')<CR>')
    call add(cmds, 'xnoremap <silent><expr> ' . g:ftjpn_T . key . ' ftjpn#Backward_O("' . g:ftjpn_T . '",' . keys . ')<CR>')
endfor

exe join(cmds, "\n")

let &cpo = s:save_cpo
unlet s:save_cpo
