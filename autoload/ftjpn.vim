let s:save_cpo = &cpo
set cpo&vim

function! ftjpn#Forward(key, list) abort
    return a:key . s:SetForwardChar(a:list)
endfunction

function! ftjpn#Backward(key, list) abort
    return a:key . s:SetBackwardChar(a:list)
endfunction

" f, t: 前方検索で利用する char の選定
function! s:SetForwardChar(list) abort
    let line = getline('.')[col('.')-1:]
    let dict = s:CreateCharDistanceDict(line, a:list)
    return s:GetClosestKey(dict, a:list)
endfunction

" F, T: 後方検索で利用する char の選定
function! s:SetBackwardChar(list) abort
    let line = reverse(getline('.')[:col('.')-1])
    let dict = s:CreateCharDistanceDict(line, a:list)
    return s:GetClosestKey(dict, a:list)
endfunction

" 距離比較。最終的なキー決定
function! s:GetClosestKey(dict, list)
    if empty(a:dict)
        return a:list[0]
    endif

    let min_key = ''
    let min_val = -1
    for [key, value] in items(a:dict)
        if min_val == -1 || value < min_val
            let min_val = value
            let min_key = key
        endif
    endfor
    return min_key
endfunction

" dict 作成
function! s:CreateCharDistanceDict(line, list) abort
    let dict = {}
    for c in a:list
        let char = '\C' . escape(c, '.*^$\[]~')
        let matchcol = match(a:line, char, 1, 1)
        if matchcol > 0
            let dict[c] = matchcol
        endif
    endfor
    return dict
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
