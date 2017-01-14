if exists("loaded_javadoc")
    finish
endif
let loaded_javadoc = 1

if !exists("g:javadoc_browser")
    if has('macunix')
        let g:javadoc_browser = "open"
    else
        let g:javadoc_browser = "/usr/bin/firefox"
    endif
endif
if !exists("g:javadoc_debug")
    let g:javadoc_debug = 0
endif

"returns a list of full paths to html files
function! s:getfiles(class)
    let tf = tempname()
    for path in split(g:javadoc_path, ":")
        if g:javadoc_debug != 0
            echo "Looking at ".path
        endif
        call system("find ".path." -type f -name '".a:class.".html' >> ".tf)
    endfor
    let lines = readfile(l:tf)
    call delete(l:tf)
    return lines
endfunction

"getfiles returns matches to 'class-use' entries that we should get rid of
function! s:filterclassuse(lines)
    let flines = []
    for line in a:lines
        if -1 == match(l:line, "class-use")
            let flines += [l:line]
        endif
    endfor
    return l:flines
endfunction

function! s:Open(class)
    if g:javadoc_debug != 0
        echo "Opening javadoc for ".a:class
    endif

    let paths = s:filterclassuse(s:getfiles(a:class))
    call system("pidof `basename ".g:javadoc_browser."`")
    let browser_closed = (v:shell_error == 1)

    let i = 0
    while i < len(l:paths)
        let path = l:paths[i]
        if g:javadoc_debug != 0
            echo "Opening ".l:path
        endif
        execute system(g:javadoc_browser." ".l:path." &")
        if l:browser_closed && len(l:paths) > 1 && i == 0
            "sleep to avoid 'Firefox is already running, but not responding.'
            :sleep 2
        endif
        let i+=1
    endwhile

    if len(l:paths) == 0
        echohl WarningMsg
        echo "Could not find javadoc for ".a:class
        echohl None
    endif
endfunction

noremap <unique> <script> <Plug>JavadocOpen <SID>Open
noremap <silent> <SID>Open :call <SID>Open(expand("<cword>"))<cr>
noremenu <script> Plugin.javadoc <SID>Open

if !hasmapto('<Plug>JavadocOpen')
    map <leader>j <Plug>JavadocOpen
endif


if !exists(":Javadoc")
    command -nargs=1 Javadoc :call s:Open(<q-args>)
endif
