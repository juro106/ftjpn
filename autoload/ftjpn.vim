" ----------------------------------------------------------
" f & t command for jadot & jacomma
" ----------------------------------------------------------

" 正規表現の形にする
function! s:ConvertRegex(char) abort
    if a:char ==# '.' || a:char ==# '\.'
        return '\.'
    elseif a:char ==# '*' || a:char ==# '\*'
        return '\*'
    elseif a:char ==# '^' || a:char ==# '\^'
        return '\^'
    elseif a:char ==# '$' || a:char ==# '\$'
        return '\$'
    elseif a:char ==# '[' || a:char ==# '\['
        return '\['
    elseif a:char ==# '~' || a:char ==# '\~'
        return '\~'
    else
        return a:char
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
endfunction

" f, t 前方検索で利用する char の選定
function! s:SetForwardChar(pattern) abort

    let col = col('.')-1
    let line = getline('.')[col:]
    " let zen = "[^\x01-\x7E]"
    " let zenline = getline('.')[col('.'):]
    let dict = {}
    let col_list = []

    for char in a:pattern
        let keyword = s:ConvertRegex(char)
        let matchcol = match(line, keyword, 1, 1)
        let dict[char] = matchcol
        if matchcol > 0
            call add(col_list, matchcol)
        endif
    endfor 

    let min_col = min(col_list)

    if len(col_list)==0
        return ''
    else
        for [key, value] in items(dict)
            if value ==# min_col
                return s:RevertRegex(key)
            endif
        endfor
    endif
endfunction

" F, T 後方検索で利用する char の選定
function! s:SetBackChar(pattern) abort
    let col = col('.')-1
    let line = getline('.')[:col]

    let dict = {}
    let col_list = []
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
        let dict[char] = matchcol
        if matchcol > 0
            call add(col_list, matchcol)
        endif
    endfor 
    
    let min_col = min(col_list)

    if len(col_list)==0
        return ''
    else
        for [key, value] in items(dict)
            if value ==# min_col
                return s:RevertRegex(key)
            endif 
        endfor
    endif
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
