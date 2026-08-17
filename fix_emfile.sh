#!/bin/bash

# ============================================================
# 脚本名称: deepin_fix_emfile.sh
# 功能描述: 解决 Node.js "Error: EMFILE: too many open files" 错误
# 适用系统: Deepin / Debian / Ubuntu 系列
# 执行方式: sudo ./deepin_fix_emfile.sh
# ============================================================

# 检查是否为 root 用户
if [ "$EUID" -ne 0 ]; then
  echo "请使用 sudo 运行此脚本"
  exit 1
fi

# 定义要设置的限制数值
LIMIT=65535

echo ">>> 正在开始修复系统最大文件打开数限制..."

# 1. 修改 /etc/security/limits.conf
# 如果不存在相关配置则添加
FILE_LIMITS="/etc/security/limits.conf"
if ! grep -q "soft nofile" "$FILE_LIMITS"; then
    echo ">>> 正在配置 $FILE_LIMITS ..."
    echo "* soft nofile $LIMIT" >> "$FILE_LIMITS"
    echo "* hard nofile $LIMIT" >> "$FILE_LIMITS"
    echo "root soft nofile $LIMIT" >> "$FILE_LIMITS"
    echo "root hard nofile $LIMIT" >> "$FILE_LIMITS"
else
    echo ">>> $FILE_LIMITS 已包含配置，跳过。"
fi

# 2. 修改 /etc/pam.d/common-session
# 确保 pam_limits.so 模块被加载
FILE_PAM="/etc/pam.d/common-session"
if ! grep -q "pam_limits.so" "$FILE_PAM"; then
    echo ">>> 正在配置 $FILE_PAM ..."
    echo "session required pam_limits.so" >> "$FILE_PAM"
else
    echo ">>> $FILE_PAM 已包含配置，跳过。"
fi

# 3. 修改 systemd 配置 (针对桌面环境和图形界面应用关键步骤)
# 编辑 /etc/systemd/system.conf
FILE_SYSTEM_CONF="/etc/systemd/system.conf"
if ! grep -q "^DefaultLimitNOFILE=" "$FILE_SYSTEM_CONF"; then
    echo ">>> 正在配置 $FILE_SYSTEM_CONF ..."
    # 如果存在注释行，取消注释；否则追加
    if grep -q "^#DefaultLimitNOFILE=" "$FILE_SYSTEM_CONF"; then
        sed -i "s|^#DefaultLimitNOFILE=.*|DefaultLimitNOFILE=$LIMIT|" "$FILE_SYSTEM_CONF"
    else
        echo "DefaultLimitNOFILE=$LIMIT" >> "$FILE_SYSTEM_CONF"
    fi
else
    echo ">>> $FILE_SYSTEM_CONF 已包含配置，跳过。"
fi

# 编辑 /etc/systemd/user.conf
FILE_USER_CONF="/etc/systemd/user.conf"
if ! grep -q "^DefaultLimitNOFILE=" "$FILE_USER_CONF"; then
    echo ">>> 正在配置 $FILE_USER_CONF ..."
    if grep -q "^#DefaultLimitNOFILE=" "$FILE_USER_CONF"; then
        sed -i "s|^#DefaultLimitNOFILE=.*|DefaultLimitNOFILE=$LIMIT|" "$FILE_USER_CONF"
    else
        echo "DefaultLimitNOFILE=$LIMIT" >> "$FILE_USER_CONF"
    fi
else
    echo ">>> $FILE_USER_CONF 已包含配置，跳过。"
fi

# 4. 针对 Node.js 开发者的额外建议
echo ""
echo ">>> 配置完成！"
echo "============================================================"
echo "重要提示："
echo "1. 必须重启电脑才能使所有配置生效。"
echo "2. 重启后在终端运行 'ulimit -n'，如果显示 65535 则表示成功。"
echo "3. 如果重启后问题依然存在，建议在 VS Code 设置中排除 node_modules 监听："
echo "   'files.watcherExclude': { '**/node_modules/**': true }"
echo "============================================================"
