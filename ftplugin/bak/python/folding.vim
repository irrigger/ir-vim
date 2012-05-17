setlocal foldmethod=expr
setlocal foldexpr=GetPythonFold(v:lnum)

function! GetPythonFold(lnum)
    if getline(a:lnum) =~? '\v^\s*$'
        if (a:lnum - 1) > 0
            if TopLevelItem(a:lnum-1) == 0
                return '1'
            endif
        endif
        return '-1'
    endif

    let top_level = TopLevelItem(a:lnum)
    if top_level >= 0
        return top_level
    endif

    let this_indent = IndentLevel(a:lnum) + 1
    let next_indent = IndentLevel(NextNonBlankLine(a:lnum)) + 1

    if next_indent == this_indent
        return this_indent
    elseif next_indent < this_indent
        return this_indent
    elseif next_indent > this_indent
        return '>' . next_indent
    endif

    return '0'
endfunction

function! IndentLevel(lnum)
    return indent(a:lnum) / &shiftwidth
endfunction

function! NextNonBlankLine(lnum)
    let numlines = line('$')
    let current = a:lnum + 1

    while current <= numlines
        if getline(current) =~? '\v\S'
            return current
        endif

        let current += 1
    endwhile

    return -2
endfunction

function! TopLevelItem(lnum)
    let numlines = line('$')
    let line = getline(a:lnum)

    if line =~# '\v^class\s\S+$' || line =~# '\v^def\s\S+$'
        return '1'
    endif

    return -2
endfunction
