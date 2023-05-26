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

if [ -n "$(command -v dnf)" ]; then
  sudo dnf install ncurses-devel python-devel python3-devel -y
  sudo dnf groupinstall "X Software Development" -y
fi

if [ -n "$(command -v apt-get)" ]; then
  sudo apt-get install build-essential libncurses-dev libncurses5-dev \
      libgnome2-dev libgnomeui-dev libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
      libcairo2-dev libx11-dev libxpm-dev libxt-dev curl default-jre \
      ninja-build gettext cmake unzip python-dev python3-dev -y
fi

git clone https://github.com/neovim/neovim $location
cd "$location"
git checkout stable

if ! make; then
  echo ""
  echo ""
  echo "Couldn't compile vim. Make sure you have the necessary build tools"
  echo ""
  exit 1;
fi

make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install

cp -r ./nvim $HOME/.config/
