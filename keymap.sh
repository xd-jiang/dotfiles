#!/bin/sh
. "$PWD/helper.sh"

# echo OS type
os_type=$(detect_os)
echo "Detected OS: $os_type"


# check os run keymap sh
if [ "$os_type" = "mac" ]; then
    KEMAP_CONFIG="$PWD/mac-karabiner-keymap.sh"
elif [ "$os_type" = "linux" ]; then
    KEMAP_CONFIG="$PWD/linux-x11-keymap.sh"
else
    echo "Unsupported OS. Skipping symlink creation."
    exit 1
fi

# run sh
sh "$KEMAP_CONFIG"

