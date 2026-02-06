#!/bin/sh
. "$PWD/helper.sh"

sudo apt install zsh
chsh -s $(which zsh)
# install oh-my-zsh 
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# echo OS type
os_type=$(detect_os)
echo "Detected OS: $os_type"

user_home=$(get_user_home)

echo "User home directory: $user_home"

MY_ZSH="$PWD/zsh"
ZSH_CUSTOM="$user_home/.oh-my-zsh/custom/plugins"


# plugins

if [ ! -d $ZSH_CUSTOM/zsh-syntax-highlighting ]
then
   git clone --depth=1 \
    https://github.com/zsh-users/zsh-syntax-highlighting.git --depth=1 \
     $ZSH_CUSTOM/zsh-syntax-highlighting
fi


if [ ! -d $ZSH_CUSTOM/zsh-syntax-highlighting ]
then
    git clone --depth=1 \
     https://github.com/zsh-users/zsh-autosuggestions.git --depth=1 \
      $ZSH_CUSTOM/zsh-autosuggestions
fi


if [ ! -d $ZSH_CUSTOM/k ]
then
  git clone --depth=1 \
      https://github.com/supercrabtree/k.git --depth=1 \
      $ZSH_CUSTOM/k
fi


if [ ! -d $ZSH_CUSTOM/git-open ]
then
   git clone --depth=1 \
    https://github.com/paulirish/git-open.git --depth=1 \
     $ZSH_CUSTOM/git-open
fi


# 生成软链接
ln -sf $PWD/zsh/.zshrc  $user_home/.zshrc
# ln -sf $PWD/zsh/.ideavimrc  $user_home/.ideavimrc
ln -sf $PWD/zsh/.vsvimrc  $user_home/.vsvimrc


# 开启vscode按键重复
$ defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false              # For VS Code
$ defaults write com.microsoft.VSCodeInsiders ApplePressAndHoldEnabled -bool false      # For VS Code Insider
$ defaults delete -g ApplePressAndHoldEnabled                                           # If necessary, reset global default

# 让zsh配置生效
source  $user_home/.zshrc
# source  $user_home/.ideavimrc
