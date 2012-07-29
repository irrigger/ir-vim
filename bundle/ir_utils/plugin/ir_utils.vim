function! Test() range
python << END

# Built-in
import re
import sys

# Third party
import vim

shift_width = int(vim.eval('&sw'))

# Must account for the difference in vim/python line index.
first = int(vim.eval('a:firstline')) - 1
last = int(vim.eval('a:lastline')) - 1

buf = vim.current.buffer
lines = buf[first:last + 1]
# find minimum indent level.
for line in lines:
    tabs = line.expandtabs(shift_width)
    sys.stdout.write('Line: %s\n' % (line))

END
endfunction

function! CommentLine() range
python << END

# Built-in
import re

# Third party
import vim

def comment_line():
    """
    This function comments out selected lines.

    @rtype: bool
    @returns: The result.

    """

    result = False
    comment_leader = None
    soft_comment = None

    shift_width = int(vim.eval('&sw'))

    if int(vim.eval('exists(\"b:comment_leader\")')):
        comment_leader = vim.eval('b:comment_leader')
    # Soft comment will check to see if the line in question has a comment
    # already.
    if int(vim.eval('exists(\"g:soft_comment\")')):
        soft_comment = int(vim.eval('g:soft_comment'))
    if comment_leader:
        min_indent = None
        buf = vim.current.buffer
        first = int(vim.eval('a:firstline'))
        last = int(vim.eval('a:lastline'))
        for i in xrange(first, last + 1):
            line_contents = buf[i - 1]
            comment = True
            if soft_comment:
                if re.search(r'^[\t\s]*?%s' % (comment_leader), line_contents):
                    comment = False
            if comment:
                if len(line_contents):
                    tmp = re.search(r'^([\t\s]*?)\S', line_contents)
                    if tmp is None:
                        continue
                    tmp = tmp.group(1)
                    tmp_len = tmp.expandtabs(shift_width)
                    if min_indent is None or len(tmp_len) < len(min_indent.expandtabs(shift_width)):
                        min_indent = tmp
        for i in xrange(first, last + 1):
            line_contents = buf[i - 1]
            comment = True
            if soft_comment:
                if re.search(r'^[\t\s]*?%s' % (comment_leader), line_contents):
                    comment = False
            if comment and len(line_contents):
                tmp_min_indent = len(min_indent.expandtabs(shift_width))
                vim.command(':%s' % (i))
                vim.command('normal %s|i%s' % (tmp_min_indent + 1, comment_leader))

            result = True

    return result

result = comment_line()

print result

END
endfunction

function! UncommentLine() range
python << END

# Built-in
import re

# Third party
import vim

def uncomment_line():
    """
    This function uncomments selected lines.

    @rtype: bool
    @returns: The result.

    """

    result = False
    comment_leader = vim.eval('b:comment_leader')
    buf = vim.current.buffer
    if comment_leader:
        first = int(vim.eval('a:firstline'))
        last = int(vim.eval('a:lastline'))
        for i in xrange(first, last + 1):
            line_contents = buf[i - 1]
            if re.search('^\s*?%s' % (comment_leader), line_contents):
                line_contents = re.sub(r'^(\s*?)%s' % (comment_leader), r'\1', line_contents)
                buf[i - 1] = line_contents
        result = True

    return result

result = uncomment_line()

print result

END
endfunction

function! ToggleLineLengthHighlight()
    let l:toggle = 0
    let l:status = 'off'
    if exists("b:ir_line_length_highlight")
        let l:toggle = b:ir_line_length_highlight
    endif
    if l:toggle == 1
        exec 'match'
        let l:toggle = 0
    else
        exec 'match WarningMsg /\%'.b:textwidth.'v.*/'
        let l:status = 'on'
        let l:toggle = 1
    endif
    let b:ir_line_length_highlight = l:toggle

    echo 'Toggled line length highlight ' . l:status

endfunction

function! Templates() range
python << END

snip_dir = vim.eval('globpath(&rtp, \"templates\")')

END
endfunction
