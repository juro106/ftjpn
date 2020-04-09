" ----------------------------------------------------------
" f & t command for jadot & jacomma
" ----------------------------------------------------------

" 正規表現の形にする
function! s:ConvertRegex(char) abort
    if a:char ==# '.'
        return '\.'
    elseif a:char ==# '*'
        return '\*'
    elseif a:char ==# '^'
        return '\^'
    elseif a:char ==# '$'
        return '\$'
    elseif a:char ==# '['
        return '\['
    elseif a:char ==# '~'
        return '\~'
    else
        return a:char
    endif
endfunction

" 正規表現の形を元に戻す
function! s:RevertRegex(char) abort
    if a:char ==# '\.'
        return '.'
    elseif a:char ==# '\*'
        return '*'
    elseif a:char ==# '\^'
        return '^'
    elseif a:char ==# '\$'
        return '$'
    elseif a:char ==# '\['
        return '['
    elseif a:char ==# '\~'
        return '~'
    else
        return a:char
    endif
endfunction

" 最終的なキー決定 
function! s:SetChar(dict)
    if len(a:dict)==0
        return ''
    else
        let min_col = min(a:dict)
        for [key, value] in items(a:dict)
            if value ==# min_col
                return s:RevertRegex(key)
            endif
        endfor
    endif
endfunction

" f, t 前方検索で利用する char の選定
function! s:SetForwardChar(pattern) abort
    let col = col('.')-1
    let line = getline('.')[col:]
    let dict = {}

    for char in a:pattern
        let keyword = s:ConvertRegex(char)
        let matchcol = match(line, keyword, 1, 1)
        if matchcol > 0
            let dict[char] = matchcol
        endif
    endfor 

    return s:SetChar(dict)
endfunction

" F, T 後方検索で利用する char の選定
function! s:SetBackChar(pattern) abort
    let col = col('.')-1
    let line = getline('.')[:col]
    let dict = {}
    let linelen = strlen(line)
    let arr = []

    while linelen > 0
        let linelen = linelen - 1
        let arr = add(arr, strcharpart(line, linelen))
    endwhile
    
    let newline = join(arr,"")

    for char in a:pattern
        let keyword = s:ConvertRegex(char)
        let matchcol = match(newline, keyword, 1, 1)
        if matchcol > 0
            let dict[char] = matchcol
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
