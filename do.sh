#!/bin/bash

echo "Where do you want to install vim?"
echo "If the directory doesn't exist, vim will be installed in the given directory"
echo "If the directory exists a new folder will be created"
read location

# Get it
if [ ! -d "$location" ]; then
  mkdir -p $location
else
  location="$location/vim"
fi

git clone https://github.com/vim/vim.git $location
cd "$location/src"

./configure \
    --enable-pythoninterp \
    --enable-cscope \
    --with-features=huge \
    --with-x

# Build and install
if ! make; then
  echo ""
  echo ""
  echo "Couldn't compile vim. Make sure you have the necessary build tools"
  echo ""
  exit 1;
fi

sudo make install

# Install LanguageTool in the same folder as vim
cd "$location"
language_tool="LanguageTool-4.3"
wget https://www.languagetool.org/download/${language_tool}.zip
unzip ${language_tool}.zip
rm ${language_tool}.zip

# Install plugins
mkdir -p ~/.vim/pack/my-plugins/start

cd ~/.vim/pack/my-plugins/start
git clone https://github.com/dpelle/vim-LanguageTool.git
git clone https://github.com/scrooloose/nerdtree.git
git clone https://github.com/jistr/vim-nerdtree-tabs.git
git clone https://github.com/scrooloose/syntastic.git
git clone https://github.com/fatih/vim-go.git
git clone https://github.com/ctrlpvim/ctrlp.vim.git
mkdir -p grep/plugin && curl -Sso grep/plugin/grep.vim https://raw.githubusercontent.com/vim-scripts/grep.vim/master/plugin/grep.vim

# Create .vimrc file
mv ~/.vimrc ~/.vimrc.back

cat > ~/.vimrc << EOM
" LanguageTool binary location for LanguageTool plugin "
let g:languagetool_jar='${location}/${language_tool}/languagetool-commandline.jar'

" I want my files to be utf-8 "
set encoding=utf-8

" Automatic syntax highlight "
syntax on

" Reload files modified outside of Vim "
set autoread

" Stop vim from creating automatic backups "
set noswapfile
set nobackup
set nowb

" Replace tabs with spaces "
set expandtab
set smarttab

" Make tabs 2 spaces wide "
set tabstop=2
set shiftwidth=2

" For Golang use tabs "
autocmd FileType go set noexpandtab

" For python use 4 spaces "
autocmd FileType python set tabstop=4
autocmd FileType python set shiftwidth=4

" If I am in an indented block of code, keep the indentation level when I "
" press enter "
set autoindent

" Show line numbers "
set number

" Highlight all occurrences of a search "
set hlsearch

" search case insensitive if term is all lowercase "
set ignorecase
set smartcase

" Highlight column 81 to help keep lines of code 80 characters or less "
set colorcolumn=81

" Allow the use of 256 colors in the terminal "
set t_Co=256

" Set some theme colors "
hi Directory guifg=#FF0000 ctermfg=68
highlight Comment ctermfg=97
highlight Search ctermfg=0 ctermbg=2

" Allows normal mode to autocomplete paths using tab like bash does "
set wildmenu
set wildmode=list:longest

" Show tabs and trailing spaces "
set list listchars=tab:→\ ,trail:·

" When choosing a file from a quickfix buffer, open in a new tab or in "
" an already opened tab "
set switchbuf+=usetab,newtab

" Shift+Tab unindents a line "
imap <S-Tab> <Esc><<i
nmap <S-tab> <<

" Remove trailing spaces when saving a file (except for md files) "
fun! StripTrailingWhiteSpace()
  if &ft =~ 'markdown'
    return
  endif
  %s/\s\+$//e
endfun
autocmd BufWritePre * :call StripTrailingWhiteSpace()

" Open nerdtree plugin when vim starts "
let g:nerdtree_tabs_open_on_console_startup=1

" Fix backspace not working "
set backspace=indent,eol,start

" Enable Ctrl+P "
set runtimepath^=~/.vim/bundle/ctrlp.vim

" No limit on how many files ctrlp should index "
let g:ctrlp_max_files=0

" Ctrl+P to open selection in new tab by default "
let g:ctrlp_prompt_mappings = {
  \ 'AcceptSelection("e")': [],
  \ 'AcceptSelection("t")': ['<cr>', '<c-m>'],
  \ }

" Let Ctrl+P find hidden files "
let g:ctrlp_show_hidden = 1

" Use directory where vim was started as search directory "
let g:ctrlp_working_path_mode = 'a'

" F2 toggles paste mode one and off "
set pastetoggle=<F2>

" <Ctrl-l> redraws the screen and removes any search highlighting. "
nnoremap <silent> <C-l> :nohl<CR><C-l>

" <Ctrl-g> calls Rgrep "
nnoremap <silent> <C-g> :Rgrep<CR>

" Use ESLint for JS files "
let g:syntastic_javascript_checkers = ['eslint']

" Don't index node_modules and bower_components folders "
set wildignore+=**/node_modules,**/bower_components

" Enable .vimrc files per project "
set exrc
set secure

" No annoying sound on errors "
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Treat long lines as break lines (useful when moving around in them) "
map j gj
map k gk

" Disallow use of arrow keys to move. Use hjkl instead "
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>

" Set the nerdtree width to 20 characters "
let g:NERDTreeWinSize = 20

" Highlight current line "
set cursorline
hi CursorLine term=bold cterm=bold guibg=Grey40 ctermbg=235

" Fixes slow scrolling on mac "
set lazyredraw

" Make y(y) and paste(p) operations use the system clipboard
set clipboard=unnamed,unnamedplus

" <leader>dt will open definition of function under cursor in new tab (vim-go) "
au FileType go nmap <leader>dt <Plug>(go-def-tab)

" Rename tabs to show tab number.
" (Based on http://stackoverflow.com/questions/5927952/whats-implementation-of-vims-default-tabline-function)
if exists("+showtabline")
    function! MyTabLine()
        let s = ''
        let wn = ''
        let t = tabpagenr()
        let i = 1
        while i <= tabpagenr('$')
            let buflist = tabpagebuflist(i)
            let winnr = tabpagewinnr(i)
            let s .= '%' . i . 'T'
            let s .= (i == t ? '%1*' : '%2*')
            let s .= ' '
            let wn = tabpagewinnr(i,'$')

            let s .= '%#TabNum#'
            let s .= i
            " let s .= '%*'
            let s .= (i == t ? '%#TabLineSel#' : '%#TabLine#')
            let bufnr = buflist[winnr - 1]
            let file = bufname(bufnr)
            let buftype = getbufvar(bufnr, 'buftype')
            if buftype == 'nofile'
                if file =~ '\/.'
                    let file = substitute(file, '.*\/\ze.', '', '')
                endif
            else
                let file = fnamemodify(file, ':p:t')
            endif
            if file == ''
                let file = '[No Name]'
            endif
            let s .= ' ' . file . ' '
            let i = i + 1
        endwhile
        let s .= '%T%#TabLineFill#%='
        let s .= (tabpagenr('$') > 1 ? '%999XX' : 'X')
        return s
    endfunction
    set stal=2
    set tabline=%!MyTabLine()
    set showtabline=1
    highlight link TabNum Special
endif
EOM
