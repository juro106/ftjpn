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
    if len(a:dict) == 0
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

" dict 処理
function! s:CreateCharDistanceDict(line, pattern) abort
	let dict = {}
	for s in a:pattern
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
