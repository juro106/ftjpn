let s:save_cpo = &cpo
set cpo&vim

" match()用 一部の記号はエスケープする
function! s:EscapeSpecialChar(s) abort
    return a:s =~# '[.*^$\[~]' ? '\' . a:s : a:s
endfunction

" 最終的なキー決定
function! s:SetChar(dict)
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

" f, t 前方検索で利用する char の選定
function! s:SetForwardChar(pattern) abort
    let col = col('.')-1
    let line = getline('.')[col:]
    let dict = {}

    for s in a:pattern
        let char = '\C' . s:EscapeSpecialChar(s)
        let matchcol = match(line, char, 1, 1)
        if matchcol > 0
            let dict[s] = matchcol
        endif
    endfor

    return s:SetChar(dict)
endfunction

" F, T 後方検索で利用する char の選定
function! s:SetBackChar(pattern) abort
    let col = col('.')-2
    let line = getline('.')[:col]
    let dict = {}
    let linelen = strlen(line)
    let arr = []

    while linelen > 0
        let linelen = linelen - 1
        let arr = add(arr, strcharpart(line, linelen))
    endwhile

    let newline = join(arr, "")

    for s in a:pattern
        let char = '\C' . s:EscapeSpecialChar(s)
        let matchcol = match(newline, char, 1, 1)
        if matchcol > 0
            let dict[s] = matchcol
        endif
    endfor

    return s:SetChar(dict)
endfunction

" ----------------------------------------------------------
" f, F & t, T
" ----------------------------------------------------------

function! ftjpn#Jfmove(pattern) abort
    exe "silent normal! " . v:count1 . "f" . s:SetForwardChar(a:pattern)
endfunction

function! ftjpn#JFmove(pattern) abort
    exe "silent normal! " . v:count1 . "F" . s:SetBackChar(a:pattern)
endfunction

function! ftjpn#Jtmove(pattern) abort
    exe "silent normal! " . v:count1 . "t" . s:SetForwardChar(a:pattern)
endfunction

function! ftjpn#JTmove(pattern) abort
    exe "silent normal! " . v:count1 . "T" . s:SetBackChar(a:pattern)
endfunction

" ----------------------------------------------------------
" Operator-pending オペレーター待機モード
" ----------------------------------------------------------

function! ftjpn#Jof(pattern) abort
    return "f" . s:SetForwardChar(a:pattern)
endfunction

function! ftjpn#JoF(pattern) abort
    return "F" . s:SetBackChar(a:pattern)
endfunction

function! ftjpn#Jot(pattern) abort
    return "t" . s:SetForwardChar(a:pattern)
endfunction

function! ftjpn#JoT(pattern) abort
    return "T" . s:SetBackChar(a:pattern)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
