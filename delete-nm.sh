#!/bin/bash

#　删除当前目录下的node_modules，包括子目录

# 设置默认路径为当前目录
path="${1:-.}"

# 检查路径是否存在
if [ ! -d "$path" ]; then
    echo "错误：路径 '$path' 不存在。"
    exit 1
fi

# 查找所有node_modules目录
echo "正在搜索 '$path' 中的 node_modules 目录..."
directories=$(find "$path" -type d -name "node_modules" -prune)

if [ -z "$directories" ]; then
    echo "未找到任何 node_modules 目录。"
    exit 0
fi

# 列出所有目录
echo "找到以下 node_modules 目录："
printf '%s\n' "$directories"


echo "正在删除..."
find "$path" -type d -name "node_modules" -prune -exec rm -rf {} \;
echo "操作完成。"
