#!/usr/bin/env bash
set -e # 遇到错误立即退出

# ============ 初始化 ============
# 引入辅助函数
if [ -f "$PWD/helper.sh" ]; then
    . "$PWD/helper.sh"
else
    echo "Error: helper.sh not found in $PWD"
    exit 1
fi

# 获取操作系统类型并转换为小写，方便比较
raw_os_type=$(detect_os)
os_type=$(echo "$raw_os_type" | tr '[:upper:]' '[:lower:]')
echo "Detected OS: $os_type"

user_home=$(get_user_home)
echo "User home directory: $user_home"

# ============ VSCode 配置路径定义 ============
VSCODE_CONFIG_DIR="$PWD/vscode-config"

# 定义源文件路径
VSCODE_KEYBINDINGS_SRC="$VSCODE_CONFIG_DIR/$os_type/keybindings.json"
VSCODE_SETTINGS_SRC="$VSCODE_CONFIG_DIR/$os_type/settings.json"

echo $VSCODE_SETTINGS_SRC

# 定义 VSCode 用户目录
case "$os_type" in
    mac)
        VSCODE_USER_DIR="$user_home/Library/Application Support/Code/User"
        ;;
    windows)
        VSCODE_USER_DIR="$user_home/AppData/Roaming/Code/User"
        ;;
    linux)
        VSCODE_USER_DIR="$user_home/.config/Code/User"
        ;;
    *)
        echo "Error: Unsupported OS type '$os_type'."
        exit 1
        ;;
esac

echo "VSCode user directory: $VSCODE_USER_DIR"

# ============ 准备目录 ============
# 如果源配置目录不存在，创建它（虽然通常应该已经存在）
if [ ! -d "$VSCODE_CONFIG_DIR" ]; then
    echo "Creating VSCode config directory..."
    mkdir -p "$VSCODE_CONFIG_DIR/snippets"
fi

# 确保 VSCode 用户目录存在（VSCode 首次运行前可能不存在）
if [ ! -d "$VSCODE_USER_DIR" ]; then
    echo "Creating VSCode User directory..."
    mkdir -p "$VSCODE_USER_DIR/snippets"
fi

# ============ 创建软链接 ============
echo "Linking VSCode configuration files..."

# 链接 settings.json
if [ -f "$VSCODE_SETTINGS_SRC" ]; then
    ln -sf "$VSCODE_SETTINGS_SRC" "$VSCODE_USER_DIR/settings.json"
    echo "  Linked settings.json"
else
    echo "  Warning: Source settings.json not found for $os_type"
fi

# 链接 keybindings.json
if [ -f "$VSCODE_KEYBINDINGS_SRC" ]; then
    ln -sf "$VSCODE_KEYBINDINGS_SRC" "$VSCODE_USER_DIR/keybindings.json"
    echo "  Linked keybindings.json"
else
    echo "  Warning: Source keybindings.json not found for $os_type"
fi

# 链接 snippets 目录下的文件
snippets_src_dir="$VSCODE_CONFIG_DIR/snippets"
snippets_dest_dir="$VSCODE_USER_DIR/snippets"

if [ -d "$snippets_src_dir" ]; then
    # 确保目标 snippets 目录存在
    mkdir -p "$snippets_dest_dir"
    
    for file in "$snippets_src_dir"/*; do
        if [ -f "$file" ]; then
            filename=$(basename "$file")
            ln -sf "$file" "$snippets_dest_dir/$filename"
            echo "  Linked snippet: $filename"
        fi
    done
else
    echo "  No snippets directory found, skipping."
fi

echo "VSCode configuration finished."

# ============ 安装 im-select ============
echo ""
echo "Installing im-select..."

install_im_select() {
    local src_file="$1"
    local dest_file="$2"
    local use_sudo="$3"

    if [ ! -f "$src_file" ]; then
        echo "Error: Source file not found at $src_file"
        return 1
    fi

    # 删除旧文件（如果存在且非软链接，或者为了强制更新）
    if [ -e "$dest_file" ] || [ -L "$dest_file" ]; then
        echo "Removing old im-select at $dest_file..."
        rm -f "$dest_file"
    fi

    echo "Copying $src_file to $dest_file..."
    
    if [ "$use_sudo" = "true" ]; then
        sudo cp "$src_file" "$dest_file"
        sudo chmod 755 "$dest_file"
    else
        cp "$src_file" "$dest_file"
        chmod 755 "$dest_file"
    fi
    
    echo "im-select installed successfully at $dest_file"
}

case "$os_type" in
    mac)
        # macOS: 安装到 /usr/local/bin (需要 sudo)
        src="./im-select"
        dest="/usr/local/bin/im-select"
        install_im_select "$src" "$dest" "true"
        ;;
    windows)
        # Windows: 优先尝试 D 盘，如果不存在则安装到用户主目录
        src="./im-select.exe"
        
        # 检查 D 盘是否存在 (在 Git Bash/MSYS 环境下通常为 /d)
        if [ -d "/d" ]; then
            dest="/d/im-select.exe"
        else
            echo "D: drive not found, falling back to Home directory."
            dest="$user_home/im-select.exe"
        fi
        
        install_im_select "$src" "$dest" "false"
        echo "Note: Ensure the directory containing 'im-select.exe' is in your PATH."
        ;;
    linux)
        echo  "skip install im-select,use linux commend"
        ;;
    *)
        echo "Skipping im-select installation for unsupported OS: $os_type"
        ;;
esac
