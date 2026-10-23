#!/usr/bin/env bash
set -e

# ============================================
# VSCode 右键菜单集成工具 (Linux)
# 支持 Deepin 文件管理器和通用文件管理器
# ============================================
#
# 用法：
#   安装：./open-in-vscode.sh
#   卸载：./open-in-vscode.sh --uninstall
#   帮助：./open-in-vscode.sh --help

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly MENU_DIR="$HOME/.local/share/deepin/dde-file-manager/oem-menuextensions"
readonly ITEM_MENU="$MENU_DIR/open-with-vscode.desktop"
readonly FOLDER_MENU="$MENU_DIR/open-folder-with-vscode.desktop"
readonly HELPER_SCRIPT="$HOME/.local/bin/code-open-helper"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

die() {
    error "$*"
    exit 1
}

# 检查 VS Code 是否安装
check_vscode() {
    if ! command -v code &>/dev/null; then
        die "未找到 code 命令，请先安装 Visual Studio Code"
    fi

    local code_bin
    code_bin="$(command -v code)"
    [[ "$code_bin" != *$'\n'* ]] || die "code 命令路径无效"

    echo "$code_bin"
}

# 创建辅助脚本
create_helper_script() {
    local code_bin="$1"

    mkdir -p "$(dirname "$HELPER_SCRIPT")"

    cat >"$HELPER_SCRIPT" <<'HELPER_EOF'
#!/bin/bash
set -e

# VS Code 辅助脚本 - 处理文件管理器传入的参数

# 检查 VS Code 是否安装
if ! command -v code &>/dev/null; then
    if command -v notify-send &>/dev/null; then
        notify-send "错误" "未安装 VS Code" -u critical
    fi
    exit 1
fi

# 获取传入的参数
SELECTED_ITEMS="$1"

# 打开选中的文件/文件夹，或当前目录
if [ -n "$SELECTED_ITEMS" ] && [ "$SELECTED_ITEMS" != "." ]; then
    code "$SELECTED_ITEMS"
else
    code "$(pwd)"
fi

# 发送成功通知（可选）
if command -v notify-send &>/dev/null; then
    notify-send "VS Code" "已打开" -u low -i code
fi
HELPER_EOF

    chmod +x "$HELPER_SCRIPT"
    info "已创建辅助脚本: $HELPER_SCRIPT"
}

# 安装菜单项
install_menu() {
    local code_bin
    code_bin=$(check_vscode)

    info "检测到 VS Code: $code_bin"

    # 创建辅助脚本
    create_helper_script "$code_bin"

    # 创建菜单目录
    mkdir -p "$MENU_DIR"

    # 创建文件/文件夹右键菜单
    cat >"$ITEM_MENU" <<EOF
[Desktop Entry]
Type=Application
Name=Open with VS Code
Name[zh_CN]=使用 VS Code 打开
Comment=Open the selected file or folder in Visual Studio Code
Comment[zh_CN]=在 Visual Studio Code 中打开选中的文件或文件夹
Exec="$code_bin" %f
Icon=vscode
Terminal=false
NoDisplay=false
X-DFM-MenuTypes=SingleFile;SingleDir;
X-Deepin-Vendor=user-custom
EOF

    # 创建空白区域右键菜单
    cat >"$FOLDER_MENU" <<EOF
[Desktop Entry]
Type=Application
Name=Open Folder in VS Code
Name[zh_CN]=在 VS Code 中打开此文件夹
Comment=Open the current folder in Visual Studio Code
Comment[zh_CN]=在 Visual Studio Code 中打开当前文件夹
Exec="$code_bin" %p
Icon=vscode
Terminal=false
NoDisplay=false
X-DFM-MenuTypes=EmptyArea;BlankArea;
X-Deepin-Vendor=user-custom
EOF

    chmod 0644 "$ITEM_MENU" "$FOLDER_MENU"

    info "VS Code 右键菜单已安装到: $MENU_DIR"
    info "菜单项："
    echo "  - $ITEM_MENU"
    echo "  - $FOLDER_MENU"
    echo ""
    warn "若菜单没有立即出现，请关闭并重新打开文件管理器"
}

# 卸载菜单项
uninstall_menu() {
    local removed=0

    if [ -f "$ITEM_MENU" ]; then
        rm -f "$ITEM_MENU"
        info "已移除: $ITEM_MENU"
        removed=1
    fi

    if [ -f "$FOLDER_MENU" ]; then
        rm -f "$FOLDER_MENU"
        info "已移除: $FOLDER_MENU"
        removed=1
    fi

    if [ -f "$HELPER_SCRIPT" ]; then
        rm -f "$HELPER_SCRIPT"
        info "已移除: $HELPER_SCRIPT"
        removed=1
    fi

    if [ $removed -eq 1 ]; then
        info "VS Code 右键菜单已卸载"
    else
        warn "未找到已安装的菜单项"
    fi
}

# 显示帮助
show_help() {
    cat <<EOF
用法: ${0##*/} [选项]

为 Linux 文件管理器添加 "使用 VS Code 打开" 右键菜单

选项:
    (无参数)           安装右键菜单
    -u, --uninstall   卸载右键菜单
    -h, --help        显示此帮助信息

示例:
    ${0##*/}              # 安装
    ${0##*/} --uninstall  # 卸载

支持的文件管理器:
    - Deepin 文件管理器
    - 其他支持 .desktop 文件的文件管理器

注意:
    - 需要先安装 Visual Studio Code
    - 安装后可能需要重启文件管理器

EOF
}

# 主函数
main() {
    case "${1:-}" in
        '')
            install_menu
            ;;
        -u|--uninstall)
            uninstall_menu
            ;;
        -h|--help)
            show_help
            ;;
        *)
            error "未知参数: $1"
            echo ""
            show_help
            exit 1
            ;;
    esac
}

main "$@"
