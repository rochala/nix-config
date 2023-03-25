"[TMUX INTEGRATION]"
if exists('$TMUX')
  function! TmuxOrSplitSwitch(wincmd, tmuxdir)
    let previous_winnr = winnr()
    call system("tmux list-panes -F '#F' | grep -q Z")
    let is_maximized = v:shell_error == 0
    call system("tmux list-panes | wc -l | bc | diff - <(echo 1)")
    let is_single_pane = v:shell_error == 0
    let tmux_pane_size = system("tmux display -p '#{pane_width}'")
    let is_pane_big_enough = winwidth('%') < (tmux_pane_size - 40)

    if is_maximized || is_single_pane || is_pane_big_enough
      silent! execute "wincmd " . a:wincmd
    endif
    if previous_winnr == winnr()
      call system("tmux select-pane -" . a:tmuxdir)
      redraw!
    endif
  endfunction

  nnoremap <silent> <C-h> :call TmuxOrSplitSwitch('h', 'L')<cr>
  nnoremap <silent> <C-j> :call TmuxOrSplitSwitch('j', 'D')<cr>
  nnoremap <silent> <C-k> :call TmuxOrSplitSwitch('k', 'U')<cr>
  nnoremap <silent> <C-l> :call TmuxOrSplitSwitch('l', 'R')<cr>
endif

highlight Normal ctermfg=7 ctermbg=0 guifg=#c5c8c6 guibg=none

hi ActiveWindow guibg=none
hi InactiveWindow guibg=#1C1C24

augroup WindowManagement
  setlocal winhighlight=Normal:ActiveWindow,NormalNC:InactiveWindow
augroup END
