"[TMUX INTEGRATION]"
if exists('$TMUX')
  function! TmuxOrSplitSwitch(wincmd, tmuxdir)
    let previous_winnr = winnr()
    silent! execute "wincmd " . a:wincmd
    if previous_winnr == winnr()
      call system("tmux select-pane -" . a:tmuxdir)
      redraw!
    endif
  endfunction

  let previous_title = substitute(system("tmux display-message -p '#{pane_title}'"), '\n', '', '')
  let &t_ti = "\<Esc>]2;vim\<Esc>\\" . &t_ti
  let &t_te = "\<Esc>]2;". previous_title . "\<Esc>\\" . &t_te

  nnoremap <silent> <C-h> :call TmuxOrSplitSwitch('h', 'L')<cr>
  nnoremap <silent> <C-j> :call TmuxOrSplitSwitch('j', 'D')<cr>
  nnoremap <silent> <C-k> :call TmuxOrSplitSwitch('k', 'U')<cr>
  nnoremap <silent> <C-l> :call TmuxOrSplitSwitch('l', 'R')<cr>
endif

highlight Normal ctermfg=7 ctermbg=0 guifg=#c5c8c6 guibg=none

hi ActiveWindow guibg=none
hi InactiveWindow guibg=#272727

augroup WindowManagement
  autocmd WinLeave * call Handle_Win_Color()
  " autocmd FocusLost * :setlocal statusline=%!lightline#statusline(1)
  " autocmd FocusGained * :setlocal statusline=%!lightline#statusline(0)
augroup END

function! Handle_Win_Color()
  setlocal winhighlight=Normal:ActiveWindow,NormalNC:InactiveWindow
endfunction


