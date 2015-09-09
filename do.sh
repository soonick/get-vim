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

# Build and install
if ! make; then
  echo ""
  echo ""
  echo "Couldn't compile vim. Make sure you have the necessary build tools"
  echo ""
  exit 1;
fi

sudo make install


# Install plugins
mkdir -p ~/.vim/autoload ~/.vim/bundle; \
curl -Sso ~/.vim/autoload/pathogen.vim \
    https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim

cd ~/.vim/bundle
git clone https://github.com/scrooloose/nerdtree.git

cd ~/.vim/bundle
git clone https://github.com/jistr/vim-nerdtree-tabs.git

mkdir -p ~/.vim/plugin
curl -Sso ~/.vim/plugin/grep.vim \
    https://raw.githubusercontent.com/vim-scripts/grep.vim/master/plugin/grep.vim

cd ~/.vim/bundle
git clone https://github.com/scrooloose/nerdcommenter.git

cd ~/.vim/bundle
git clone https://github.com/scrooloose/syntastic.git

cd ~/.vim
git clone https://github.com/kien/ctrlp.vim.git bundle/ctrlp.vim


# Create .vimrc file
mv ~/.vimrc ~/.vimrc.back

cat > ~/.vimrc << EOM
" I want my files to be utf-8 "
set encoding=utf-8

" Automatic syntax highlight "
syntax on

" Necessary for NerdCommenter to work "
filetype plugin on

" Reload files modified outside of Vim "
set autoread

" Stop vim from creating automatic backups "
set noswapfile
set nobackup
set nowb

" Replace tabs with spaces "
set expandtab

" Make tabs 2 spaces wide "
set tabstop=2
set shiftwidth=2

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

" Allow the use of 256 colors in the terminal "
set t_Co=256

" Remove trailing spaces when saving a file "
autocmd BufWritePre * :%s/\s\+$//e

" Start pathogen plugins "
call pathogen#infect()

" Open nerdtree plugin when vim starts "
let g:nerdtree_tabs_open_on_console_startup=1

" Fix backspace not working "
set backspace=indent,eol,start

" Enable Ctrl+P "
set runtimepath^=~/.vim/bundle/ctrlp.vim

" F2 toggles paste mode one and off "
set pastetoggle=<F2>
EOM
