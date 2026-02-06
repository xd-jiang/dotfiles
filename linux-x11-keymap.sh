#!/bin/bash

# 检查是否为 root 权限
if [ "$(id -u)" -ne 0 ]; then
    echo "该脚本需要 root 权限，正在尝试使用 sudo..."
    exec sudo "$0" "$@"
    exit $?
fi

# 定义文件路径和备份路径
EVDEV_FILE="/usr/share/X11/xkb/keycodes/evdev"
BACKUP_FILE="${EVDEV_FILE}.bak"

# 备份原始文件
backup_evdev() {
    if [ ! -f "$BACKUP_FILE" ]; then
        cp "$EVDEV_FILE" "$BACKUP_FILE" && echo "备份已创建: $BACKUP_FILE"
    else
        echo "备份文件已存在，跳过备份。"
    fi
}

# 修改键码映射
modify_keycodes() {
    echo "正在修改键码映射..."
    sed -i '
        s/<LALT> = 64;/<LALT> = 37;  \/\/ Modified to Left Ctrl/
        s/<LCTL> = 37;/<LCTL> = 64;  \/\/ Modified to Left Alt/
        s/<CAPS> = 66;/<CAPS> = 9;   \/\/ Modified to Escape/
    ' "$EVDEV_FILE"
    echo "修改完成！"
}

# 验证修改
verify_changes() {
    echo "验证修改结果："
    grep -E '<LALT>|<LCTL>|<CAPS>' "$EVDEV_FILE"
}

# 恢复默认配置
restore_default() {
    read -p "是否要恢复原始配置？ (y/n) " choice
    case "$choice" in
        y|Y)
            cp "$BACKUP_FILE" "$EVDEV_FILE" && echo "原始配置已恢复。"
            exit 0
            ;;
        *)
            echo "取消恢复。"
            ;;
    esac
}

# 主流程
case "$1" in
    --restore)
        restore_default
        ;;
    *)
        backup_evdev
        modify_keycodes
        verify_changes
        echo -e "\n请重启系统或执行以下命令立即生效："
        echo "sudo systemctl restart lightdm"
        ;;
esac

exit 0
