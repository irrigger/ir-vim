
function! FixExecute()
silent! %s/nuke_execute\.execute(\([A-z0-9_\.\[\]'"]\+\))/\1()
silent! %s/nuke_execute\.execute(\([A-z0-9_\.\[\]'"]\+\),\s/\1(
silent! %s/nuke_execute\.execute(\([A-z0-9_\.\[\]'"]\+()[A-z0-9_\.\[\]'"]\+\)[,\ ]\+/\1(
silent! %s/nuke_execute\.execute(\([A-z0-9_\.\[\]'"]\+()[A-z0-9_\.\[\]'"]\+\)/\1(
endfunction

function! FixRun()
silent! %s/nuke_threading\.run(\([A-z0-9_\.\[\]'"]\+\))/\1()
silent! %s/nuke_threading\.run(\([A-z0-9_\.\[\]'"]\+\),\s/\1(
silent! %s/nuke_threading\.run(\([A-z0-9_\.\[\]'"]\+()[A-z0-9_\.\[\]'"]\+\)[,\ ]\+/\1(
silent! %s/nuke_threading\.run(\([A-z0-9_\.\[\]'"]\+()[A-z0-9_\.\[\]'"]\+\)/\1(
endfunction
