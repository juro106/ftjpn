let s:save_cpo = &cpo
set cpo&vim

" Normal Mode
function! ftjpn#Forward_N(key, pattern) abort
    exe "silent normal! " . v:count1 . a:key . s:SetForwardChar(a:pattern)
endfunction

function! ftjpn#Backward_N(key, pattern) abort
    exe "silent normal! " . v:count1 . a:key . s:SetBackwardChar(a:pattern)
endfunction

" Operator-pending Mode
function! ftjpn#Forward_O(key, pattern) abort
    return a:key . s:SetForwardChar(a:pattern)
endfunction

function! ftjpn#Backward_O(key, pattern) abort
    return a:key . s:SetBackwardChar(a:pattern)
endfunction

" f, t: 前方検索で利用する char の選定
function! s:SetForwardChar(pattern) abort
    let line = getline('.')[col('.')-1:]
    let dict = s:CreateCharDistanceDict(line, a:pattern)
    return s:GetClosestKey(dict)
endfunction

" F, T: 後方検索で利用する char の選定
function! s:SetBackwardChar(pattern) abort
    let line = reverse(getline('.')[:col('.')-1])
    let dict = s:CreateCharDistanceDict(line, a:pattern)
    return s:GetClosestKey(dict)
endfunction

" 最終的なキー決定
function! s:GetClosestKey(dict)
    if len(a:dict)==0
        return ''
    else
        let min_col = min(a:dict)
        for [key, value] in items(a:dict)
            if value ==# min_col
                return key
            endif
        endfor
    endif
endfunction

" match()用 一部の記号はエスケープする
function! s:EscapeSpecialChar(s) abort
    return a:s =~# '[.*^$\[~]' ? '\' . a:s : a:s
endfunction

" dict 処理
function! s:CreateCharDistanceDict(line, pattern) abort
	let dict = {}
	for s in a:pattern
		let char = '\C' . s:EscapeSpecialChar(s)
		let matchcol = match(a:line, char, 1, 1)
		if matchcol > 0
			let dict[s] = matchcol
		endif
	endfor
	return dict
endfunction

" setup
augroup ftjpn_async
    autocmd!
    autocmd VimEnter * call ftjpn#async_setup()
augroup END

function! ftjpn#async_setup()

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

        exe  'nnoremap <silent> ' . g:ftjpn_f . key . ' :<C-u>call ftjpn#Forward_N("' . g:ftjpn_f . '",' . keys . ')<CR>'
        exe  'nnoremap <silent> ' . g:ftjpn_t . key . ' :<C-u>call ftjpn#Forward_N("' . g:ftjpn_t . '",' . keys . ')<CR>'
        exe  'nnoremap <silent> ' . g:ftjpn_F . key . ' :<C-u>call ftjpn#Backward_N("' . g:ftjpn_F . '",' . keys . ')<CR>'
        exe  'nnoremap <silent> ' . g:ftjpn_T . key . ' :<C-u>call ftjpn#Backward_N("' . g:ftjpn_T . '",' . keys . ')<CR>'
        exe  'onoremap <silent><expr> ' . g:ftjpn_f . key . ' ftjpn#Forward_O("' . g:ftjpn_f . '",' . keys . ')'
        exe  'onoremap <silent><expr> ' . g:ftjpn_t . key . ' ftjpn#Forward_O("' . g:ftjpn_t . '",' . keys . ')'
        exe  'onoremap <silent><expr> ' . g:ftjpn_F . key . ' ftjpn#Backward_O("' . g:ftjpn_F . '",' . keys . ')'
        exe  'onoremap <silent><expr> ' . g:ftjpn_T . key . ' ftjpn#Backward_O("' . g:ftjpn_T . '",' . keys . ')'
        exe  'xnoremap <silent><expr> ' . g:ftjpn_f . key . ' ftjpn#Forward_O("' . g:ftjpn_f . '",' . keys . ')'
        exe  'xnoremap <silent><expr> ' . g:ftjpn_t . key . ' ftjpn#Forward_O("' . g:ftjpn_t . '",' . keys . ')'
        exe  'xnoremap <silent><expr> ' . g:ftjpn_F . key . ' ftjpn#Backward_O("' . g:ftjpn_F . '",' . keys . ')'
        exe  'xnoremap <silent><expr> ' . g:ftjpn_T . key . ' ftjpn#Backward_O("' . g:ftjpn_T . '",' . keys . ')'

    endfor
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
