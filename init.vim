" -----------------------------------PLUGINS------------------------------------

call plug#begin()

Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'kien/ctrlp.vim'
Plug 'inkarkat/argtextobj.vim'
Plug 'puremourning/vimspector'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'morhetz/gruvbox'

call plug#end()

" ----------------------------------FUNCTIONS-----------------------------------

function AddSemicolon()
    execute "normal! mqA;\<esc>`q"
endfunction

function! MakeHeader(str, length)
    let remaining = a:length - len(a:str)
    let leftchars = remaining / 2
    let rightchars = remaining - leftchars

    " echom "normal! dd" . leftchars . "i-\<esc>a" . a:str . "\<esc>" . rightchars . "a\<esc>"
    execute "normal! cc\<esc>" . leftchars . "i-\<esc>a" . a:str . "\<esc>" . rightchars . "a-\<esc>"
endfunction

function! Headerify()
    execute "normal! cc"
    let str = @"
    let str = str[:-2]
    call MakeHeader(str, 78)
endfunction

" -----------------------------------SETTINGS-----------------------------------

"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif

" configure line number 
set number
set relativenumber

" tab settings
set tabstop=4
set shiftwidth=4
set expandtab
set smarttab

" leader settings
let mapleader = " "
let maplocalleader = "\\"

" statusline
set statusline=%f         " Path to the file
set statusline+=%=        " Switch to the right side
set statusline+=%p%{'%'}  " Percent in file
set statusline+=/         " Separator
set statusline+=%L        " Total lines
set statusline+=%y        " Filetype of the file

" restore last position in file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" -------------------------------------KEYS-------------------------------------

" reload config
nnoremap <leader><f5> :source $MYVIMRC<cr>

"autocomplete

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

inoremap <silent><expr> <c-space> coc#refresh()
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gD :call CocAction('jumpDefinition')<CR>:vs<cr><c-o>
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nnoremap <silent> K :call <SID>show_documentation()<CR>

"debugger
nnoremap <f5> :call vimspector#Launch()<cr>
nnoremap <f9> :call vimspector#ToggleBreakpoint()<cr>

" can't use f11 because it is used by the window manager
nnoremap <leader>dd :call vimspector#StepOver()<cr>
nnoremap <f10> :call vimspector#StepOver()<cr>
nnoremap <leader>do :call vimspector#StepOver()<cr>
nnoremap <leader>di :call vimspector#StepInto()<cr>
nnoremap <leader>ds :call vimspector#Reset()<cr>
nnoremap <leader>dc :call vimspector#Continue()<cr>

nnoremap <leader>dw :call vimspector#AddWatch()<cr>
nnoremap <leader>dW :call vimspector#DeleteWatch()<cr>


" save using ctrl+s
nnoremap <c-s> :w<cr>


" add semicolon to the end of the line
nnoremap <leader>; :call AddSemicolon()<cr>


" todo: configure to select the current argument
onoremap iA :<c-u>normal! f(vi(<cr>

" autoclose parens
inoremap (; ()<C-c>ha
inoremap {; {}<C-c>ha
inoremap [; []<C-c>ha
inoremap (<space> ()<C-c>ha
inoremap {<space> {}<C-c>ha
inoremap [<space> []<C-c>ha
inoremap (<cr> (<cr>)<C-c>k$o
inoremap {<cr> {<cr>}<C-c>k$o
inoremap [<cr> [<cr>]<C-c>k$o

inoremap "" ""<C-c>ha
inoremap '' ''<C-c>ha

" ctrl + backspace in insert mode
noremap! <C-BS> <C-w>
noremap! <C-h> <C-w>

" commenting
vnoremap <c-_> :Commentary<cr>
nnoremap <c-_> :Commentary<cr>

" remap arrow keys to move between windows
nnoremap <left> <c-w><left>
nnoremap <right> <c-w><right>
nnoremap <up> <c-w><up>
nnoremap <down> <c-w><down>

" swtich header and source files
nnoremap <c-k><c-o> :execute 'edit' CocRequest('clangd', 'textDocument/switchSourceHeader', {'uri': 'file://'.expand("%:p")})<cr>

" colorscheme
autocmd vimenter * ++nested colorscheme gruvbox

" close other windows by double tapping escape
nnoremap <esc><esc> :only<cr>

" misc
nnoremap <leader>H :call Headerify()<cr>
nnoremap Y y$

