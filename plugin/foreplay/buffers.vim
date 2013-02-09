if exists("g:loaded_buffers") || v:version < 700 || &cp
  finish
endif
let g:loaded_buffers = 1

if !exists("g:foreplay#result_buffer_size")
  let g:foreplay#result_buffer_size = 10
endif

" valid options are 'top' or 'bottom'
if !exists("g:foreplay#result_buffer_location")
  let g:foreplay#result_buffer_location = 'top'
endif

let s:buf_name = "__RESULT__"

function! s:create_result_buffer()
  exe g:foreplay#result_buffer_size . "new " . s:buf_name
  setlocal buftype=nofile
  setlocal filetype=clojure
  setlocal bufhidden=hide
  setlocal noswapfile
endfunction

function! s:result_buffer_is_visible()
  for i in tabpagebuflist()
    if bufname(i) == s:buf_name
      return 1
    endif
  endfor
  return 0
endfunction

function! s:open_result_buffer_window(buf_num)
  if s:result_buffer_is_visible() == 1
    for i in range(1, winnr('$'))
      exe i . "  wincmd w"
      if bufname('%') == s:buf_name
        return i
      endif
    endfor
  else
    exe g:foreplay#result_buffer_size . "split +buffer" . a:buf_num
  endif
endfunction

function! buffers#open_buffer()
  if bufnr(s:buf_name) != -1
    call s:open_result_buffer_window(bufnr(s:buf_name))
  else
    call s:create_result_buffer()
  endif
endfunction
