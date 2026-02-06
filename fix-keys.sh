#!/bin/bash

# 永久交换左Ctrl/左Alt，并将CapsLock改为Escape
# 使用推荐的XKB选项方法 deepIn os 25

# 检查权限
if [ "$(id -u)" -ne 0 ]; then
    echo "该脚本需要 root 权限，正在尝试使用 sudo..."
    exec sudo "$0" "$@"
    exit $?
fi

# 配置目录和文件
CONF_DIR="/etc/X11/xorg.conf.d"
CONF_FILE="$CONF_DIR/00-keyboard.conf"

# 创建配置目录
mkdir -p "$CONF_DIR"

# 创建配置文件
echo 'Section "InputClass"
    Identifier "system-keyboard"
    MatchIsKeyboard "on"
    Option "XkbOptions" "ctrl:swap_lalt_lctl,caps:escape"
EndSection' > "$CONF_FILE"

echo "配置已写入: $CONF_FILE"

# 立即应用设置
if command -v setxkbmap >/dev/null; then
    echo "正在应用新键位设置..."
    setxkbmap -option
    setxkbmap -option ctrl:swap_lalt_lctl,caps:escape
    
    # Deepin 特殊处理：重置键盘布局
    if command -v gsettings >/dev/null; then
        gsettings reset org.gnome.desktop.input-sources xkb-options
        gsettings set org.gnome.desktop.input-sources xkb-options "['ctrl:swap_lalt_lctl', 'caps:escape']"
    fi
fi

# 验证并提示
echo -e "\n验证当前设置:"
setxkbmap -query | grep options
echo -e "\n键位修改已完成！结果："
echo "1. 左Ctrl 和 左Alt 已交换"
echo "2. CapsLock 变为 Escape 键"
echo ""
echo "温馨提示："
echo "• 重启系统可使所有环境生效"
echo "• 当前会话修改已立即生效"

# 可选的自动重启
if [ "$1" = "--auto-reboot" ]; then
    echo -e "\n将在10秒后自动重启..."
    sleep 10
    reboot
fi
