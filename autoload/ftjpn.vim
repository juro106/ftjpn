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

" 最終的なキー決定
function! s:GetClosestKey(dict, list)
    if len(a:dict) == 0
        return a:list[0]
    endif

    let min_col = min(a:dict)
    for [key, value] in items(a:dict)
        if value ==# min_col
            return key
        endif
    endfor
endfunction

" dict 処理
function! s:CreateCharDistanceDict(line, list) abort
    let dict = {}
    for s in a:list
        let char = '\C' . escape(s, '.*^$\[]~')
        let matchcol = match(a:line, char, 1, 1)
        if matchcol > 0
            let dict[s] = matchcol
        endif
    endfor
    return dict
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
