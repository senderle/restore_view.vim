"   restore_view.vim
"
"   Maintainers: Scott Enderle (scott.enderle at gmail)
"                Yichao Zhou (broken.zhou at gmail)
"       Version: 1.3
"   Description: 
"       This is a simple script to autosave cursor position and fold
"       information using vim's mkview. Although you can do this with
"       a couple of lines in your vimrc, this takes care of a few
"       possible error conditions. Requires a newish Vim. (TODO: how new?)
"
"       Views will be saved when you write a file or exit.
"
"       This script does not apply any specific view options, so you'll
"       need to set your own. E.g.: 
"
"           set viewoptions=cursor,folds,slash,unix

if exists("g:loaded_restore_view")
    finish
endif
let g:loaded_restore_view = 1

if !exists("g:skipview_files")
    let g:skipview_files = []
endif

function! MakeViewCheck()
    if &l:diff | return 0 | endif
    if &buftype != '' | return 0 | endif
    if expand('%') =~ '\[.*\]' | return 0 | endif
    if empty(glob(expand('%:p'))) | return 0 | endif
    if &modifiable == 0 | return 0 | endif
    if len($TEMP) && expand('%:p:h') == $TEMP | return 0 | endif
    if len($TMP) && expand('%:p:h') == $TMP | return 0 | endif

    let file_name = expand('%:p')
    for ifiles in g:skipview_files
        if file_name =~ ifiles
            return 0
        endif
    endfor

    return 1
endfunction

augroup AutoView
    autocmd!
    " Autosave & Load Views.
    autocmd BufWritePre,BufWinLeave ?* if MakeViewCheck() | silent! mkview | endif
    autocmd BufWinEnter ?* if MakeViewCheck() | silent! loadview | endif
augroup END
