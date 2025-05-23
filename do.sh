#!/bin/bash

set -e

echo "Where do you want to install vim?"
echo "If the directory doesn't exist, vim will be installed in the given directory"
read location

# This makes this script work when the command is run by root (which is
# common when running inside a docker container)
sudo ()
{
    [[ $EUID = 0 ]] || set -- command sudo "$@"
    "$@"
}

# Get it
if [ ! -d "$location" ]; then
  mkdir -p $location
else
  echo "Vim souce directory already exists aborting"
  exit 1
fi

if [ -n "$(command -v dnf)" ]; then
  sudo dnf install ncurses-devel python-devel python3-devel -y
  sudo dnf groupinstall "X Software Development" -y
fi

if [ -n "$(command -v apt-get)" ]; then
  sudo apt-get install build-essential libncurses-dev libncurses5-dev npm golang \
      libgtk2.0-dev libatk1.0-dev libcairo2-dev libx11-dev libxpm-dev libxt-dev \
      curl default-jre ninja-build gettext make cmake unzip python3-dev ripgrep \
      xclip -y
fi

current_folder=$(pwd)
git clone --depth=1 -b stable https://github.com/neovim/neovim $location
cd "$location"
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install

cd $current_folder
cp -r ./nvim $HOME/.config/nvim
