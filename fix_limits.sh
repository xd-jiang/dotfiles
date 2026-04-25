#!/bin/bash

# 为了修复前端监控的文件过多，会出现：Error: EMFILE: too many open file
# 获取当前执行脚本的真实用户名
CURRENT_USER=$(whoami)
LIMITS_FILE="/etc/security/limits.conf"

echo "=================================================="
echo " 当前用户: $CURRENT_USER"
echo " 目标文件: $LIMITS_FILE"
echo "=================================================="

# 检查是否已经配置过，避免重复添加 (使用正则匹配 soft 或 hard 的 nofile 65535)
if grep -qE "^${CURRENT_USER}[[:space:]]+(soft|hard)[[:space:]]+nofile[[:space:]]+65535" "$LIMITS_FILE"; then
    echo "✅ 检测到配置已存在，无需重复添加。"
    echo ""
    echo "⚠️  请确保你已【完全关闭】当前的终端窗口，并重新打开一个新终端，配置才会生效！"
    exit 0
fi

# 使用 sudo 追加配置
echo "👉 正在请求管理员权限以修改系统配置..."
echo "$CURRENT_USER soft nofile 65535" | sudo tee -a "$LIMITS_FILE" > /dev/null
echo "$CURRENT_USER hard nofile 65535" | sudo tee -a "$LIMITS_FILE" > /dev/null

# 检查上一条 sudo 命令是否执行成功
if [ $? -eq 0 ]; then
    echo "=================================================="
    echo "✅ 配置修改成功！"
    echo "   已为用户 '$CURRENT_USER' 设置最大打开文件数为 65535。"
    echo "=================================================="
    echo ""
    echo "⚠️  【非常重要】下一步操作："
    echo "1. 完全关闭当前的终端窗口（如果用的 VS Code，把 VS Code 整个重启一遍最保险）。"
    echo "2. 重新打开终端。"
    echo "3. 输入命令 ulimit -n 检查，如果输出 65535 说明配置成功。"
else
    echo "❌ 配置修改失败！"
    echo "可能原因：密码输入错误 或 当前用户没有 sudo 权限。"
    exit 1
fi
