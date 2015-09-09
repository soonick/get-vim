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

# Build it
if ! make; then
  echo ""
  echo ""
  echo "Couldn't compile vim. Make sure you have the necessary build tools"
  echo ""
  exit 1;
fi

sudo make install
