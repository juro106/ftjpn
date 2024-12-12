let s:save_cpo = &cpo
set cpo&vim

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

" Normal Mode
function! ftjpn#Jfmove(pattern) abort
    exe "silent normal! " . v:count1 . "f" . s:SetForwardChar(a:pattern)
endfunction

function! ftjpn#JFmove(pattern) abort
    exe "silent normal! " . v:count1 . "F" . s:SetBackwardChar(a:pattern)
endfunction

function! ftjpn#Jtmove(pattern) abort
    exe "silent normal! " . v:count1 . "t" . s:SetForwardChar(a:pattern)
endfunction

function! ftjpn#JTmove(pattern) abort
    exe "silent normal! " . v:count1 . "T" . s:SetBackwardChar(a:pattern)
endfunction

" Operator-pending Mode
function! ftjpn#Jof(pattern) abort
    return "f" . s:SetForwardChar(a:pattern)
endfunction

function! ftjpn#JoF(pattern) abort
    return "F" . s:SetBackwardChar(a:pattern)
endfunction

function! ftjpn#Jot(pattern) abort
    return "t" . s:SetForwardChar(a:pattern)
endfunction

function! ftjpn#JoT(pattern) abort
    return "T" . s:SetBackwardChar(a:pattern)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
