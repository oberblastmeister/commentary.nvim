" nnoremap <Plug>CommentaryLine <cmd>lua require'commentary'.line()<CR>
nnoremap <Plug>Commentary <cmd>set opfunc=Comment<CR>g@
nnoremap <Plug>CommentaryLine <cmd>lua require'commentary'.comment()<CR>
" nnoremap <expr> <Plug>CommentaryLine set opfunc=Comment<CR>g@

function! Comment(type, ...) abort
  lua require'commentary'.comment(true)
endfunction

nmap gc <Plug>Commentary
nmap gcc <Plug>CommentaryLine
" nnoremap <leader>u :set opfunc=CountSpaces<CR>g@
" vnoremap <leader>u :<C-U>call CountSpaces(visualmode(), 1)<CR>

function! CountSpaces(type, ...)
  let sel_save = &selection
  let &selection = "inclusive"
  let reg_save = @@

  if a:0  " Invoked from Visual mode, use gv command.
    silent exe "normal! gvy"
  elseif a:type == 'line'
    silent exe "normal! '[V']y"
  else
    silent exe "normal! `[v`]y"
  endif

  echomsg strlen(substitute(@@, '[^ ]', '', 'g'))

  let &selection = sel_save
  let @@ = reg_save
endfunction

" nmap <leader>c <Plug>Commentary
" nmap <leader>cc <Plug>CommentaryLine
