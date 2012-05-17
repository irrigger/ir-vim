function! DoRunPythonBuffer()
    " force preview window closed
    pclose!
    setlocal ft=python

    " copy the buffer into a new window, then run that buffer through python
    sil %y a | below 15 new | sil put a | sil %!python -
    " indicate the output window as the current previewwindow
    setlocal previewwindow ro nomodifiable nomodified

    " back into the original window
    " winc p
endfu


