#!/bin/sh

KAR_DIR="$HOME/.config/karabiner/assets/complex_modifications/"
if [ ! -d KAR_DIR ]
    echo 'karabiner dir not found'
then
  ln -sf $PWD/karabiner/* $KAR_DIR
fi
    
