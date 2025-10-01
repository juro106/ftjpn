let s:save_cpo = &cpo
set cpo&vim

function! ftjpn#Forward(key, list) abort
    let line = getline('.')[col('.')-1:]
    return a:key . s:GetClosestChar(line, a:list)
endfunction

function! ftjpn#Backward(key, list) abort
    let line = reverse(getline('.')[:col('.')-1])
    return a:key . s:GetClosestChar(line, a:list)
endfunction

" line の中でカーソルから最寄りの文字を返す
function! s:GetClosestChar(line, list) abort
    " 比較用 dict {char: col, ...} (dictionary型) を作成
    let dict = {}
    for c in a:list
        let regex_pattern = '\C' . escape(c, '.*^$\[]~')
        let matchcol = match(a:line, regex_pattern, 1, 1)
        if matchcol > 0
            let dict[c] = matchcol
        endif
    endfor

    if empty(dict)
        return a:list[0]
    endif

    " 距離比較。最終的なキー決定
    let min_key = ''
    let min_val = -1
    for [key, value] in items(dict)
        if min_val == -1 || value < min_val
            let min_val = value
            let min_key = key
        endif
    endfor
    return min_key
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
