#!/usr/bin/env bash

set -Eeuo pipefail

# Deepin 文件管理器：添加/移除“使用 VS Code 打开”右键菜单。
#
# 安装：./install.sh
# 卸载：./install.sh --uninstall

readonly MENU_DIR="$HOME/.local/share/deepin/dde-file-manager/oem-menuextensions"
readonly ITEM_MENU="$MENU_DIR/open-with-vscode.desktop"
readonly FOLDER_MENU="$MENU_DIR/open-folder-with-vscode.desktop"

die() {
    printf '错误：%s\n' "$*" >&2
    exit 1
}

uninstall_menu() {
    rm -f -- "$ITEM_MENU" "$FOLDER_MENU"
    printf '已移除 VS Code 右键菜单。\n'
}

install_menu() {
    local code_bin

    code_bin="$(command -v code || true)"
    [[ -n "$code_bin" ]] || die '未找到 code 命令，请先安装 Visual Studio Code。'
    [[ "$code_bin" != *$'\n'* ]] || die 'code 命令路径无效。'

    mkdir -p -- "$MENU_DIR"

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

    chmod 0644 -- "$ITEM_MENU" "$FOLDER_MENU"

    printf 'VS Code 右键菜单已安装到：\n%s\n' "$MENU_DIR"
    printf '若菜单没有立即出现，请关闭并重新打开文件管理器。\n'
}

case "${1:-}" in
    '')
        install_menu
        ;;
    --uninstall|-u)
        uninstall_menu
        ;;
    --help|-h)
        printf '用法：%s [--uninstall]\n' "${0##*/}"
        ;;
    *)
        die "未知参数：$1"
        ;;
esac
