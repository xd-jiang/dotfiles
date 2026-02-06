#!/bin/sh

. "$PWD/helper.sh"

# echo OS type
os_type=$(detect_os)
echo "Detected OS: $os_type"

user_home=$(get_user_home)

echo "User home directory: $user_home"

# check if vscode snippets directory exists
if [ ! -d "$VSCODE_CONFIG_DIR" ]; then
    echo "Creating VSCode config directory..."
    mkdir -p "$VSCODE_CONFIG_DIR/snippets"
fi

VSCODE_CONFIG_DIR="$PWD/vscode-config"

VSCODE_KEYBINDINGS_FILE="$VSCODE_CONFIG_DIR/$os_type/keybindings.json"
VSCODE_SETTINGS_FILE="$VSCODE_CONFIG_DIR/$os_type/settings.json"

# setup VSCode keybindings and settings
if [ "$os_type" = "mac" ]; then
    VSCODE_USER_DIR="$user_home/Library/Application Support/Code/User"
elif [ "$os_type" = "windows" ]; then
    VSCODE_USER_DIR="$user_home/AppData/Roaming/Code/User"
elif [ "$os_type" = "linux" ]; then
    VSCODE_USER_DIR="$user_home/.config/Code/User"
else
    echo "Unsupported OS. Skipping symlink creation."
    exit 1
fi


echo $VSCODE_SETTINGS_FILE
echo "VSCode user directory: $VSCODE_USER_DIR"

# create symlinks
ln -sf "$VSCODE_KEYBINDINGS_FILE" "$VSCODE_USER_DIR/keybindings.json"
ln -sf "$VSCODE_SETTINGS_FILE" "$VSCODE_USER_DIR/settings.json"

# create snippets files symlinks
for file in "$VSCODE_CONFIG_DIR"/snippets/*; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        ln -sf "$file" "$VSCODE_USER_DIR/snippets/$filename"
    fi
done
echo "Symlinks created successfully."

####### im-select installation #########
# if im-select already exist, delete it and copy it again
if [ "$os_type" = "Mac" ]; then
    if [ -e /usr/local/bin/im-select ]; then
        rm -f /usr/local/bin/im-select
    fi

    echo "* Copy im-select..."

    cp ./im-select /usr/local/bin/im-select

    chmod 755 /usr/local/bin/im-select

    echo "* im-select is installed!"
    echo "* now run \"im-select\" in your terminal!"
elif [ "$os_type" = "Windows" ]; then
# need have D:\ drive
    if [ -e "D:\\iim-select.exe" ]; then
        rm -f "D:\\iim-select.exe"
    fi

    echo "* Copy im-select..."

    cp ./im-select.exe "D:\\im-select.exe"

    chmod 755 "D:\\iim-select.exe"

    echo "* im-select is installed!"
    echo "* now run \"im-select\" in your terminal!"
fi
