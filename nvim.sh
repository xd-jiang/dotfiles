#!/bin/sh
. "$PWD/helper.sh"

user_home=$(get_user_home)

echo "User home directory: $user_home"

NVIM_DIR="$user_home/.config/"


# Install neovim needed fonticons
# brew tap homebrew/cask-fonts
# brew install --cask font-hack-nerd-font

# github clone socket proxy config 
# 9981 is the port of shadowsocks
git config --global http.https://github.com.proxy socks5://127.0.0.1:7890
git config --global https.https://github.com.proxy socks5://127.0.0.1:7890

echo $NVIM_DIR
echo $PWD


sudo rm -r ~/.local/share/nvim/
sudo rm -r ~/.local/state/nvim/

rm -rf $NVIM_DIR/nvim
mkdir -p $NVIM_DIR

# rm -rf $NVIM_DIR/kitty
# mkdir -p $NVIM_DIR/kitty
# ln -sf  ./kitty/* $NVIM_DIR/kitty/

cp -R $PWD/nvim $NVIM_DIR
