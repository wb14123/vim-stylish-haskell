if !exists("g:stylish_haskell_command")
  let g:stylish_haskell_command = "stylish-haskell"
endif

function! s:OverwriteBuffer(output)
  let winview = winsaveview()
  silent! undojoin
  normal! ggdG
  call append(0, split(a:output, '\v\n'))
  normal! Gdd
  call winrestview(winview)
endfunction

function! s:StylishHaskell()
  let output = system(g:stylish_haskell_command . " " . bufname("%"))
  let errors = matchstr(output, '\(Language\.Haskell\.Stylish\.Parse\.parseModule:[^\x0]*\)')
  if v:shell_error != 0
    echom output
  elseif empty(errors)
    call s:OverwriteBuffer(output)
    write
  else
    echom errors
  endif
endfunction

augroup stylish-haskell
  autocmd!
  autocmd BufWritePost *.hs call s:StylishHaskell()
augroup END
