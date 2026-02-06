# Hammerspoon 
HS_DIR="$HOME/.hammerspoon"
echo $HS_DIR

if [ ! -d $HS_DIR ]
then
    mkdir -p $HS_DIR
else
    rm -rf $HS_DIR
    mkdir -p $HS_DIR
fi
ln -sf $PWD/hammerspoon/* $HS_DIR



