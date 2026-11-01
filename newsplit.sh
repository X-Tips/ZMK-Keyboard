#!/bin/bash
# 退回根目录运行下面命令: cd /workspaces/ZMK-Studio
# 用法: bash newsplit.sh <源键盘> <新键盘>
# 示例: bash newsplit.sh x18n x200n

OLD=$1
NEW=$2

if [ -z "$OLD" ] || [ -z "$NEW" ]; then
    echo "用法: bash newsplit.sh <源键盘名> <新键盘名>"
    exit 1
fi

if [ ! -d "$OLD" ]; then
    echo "❌ 源键盘目录 '$OLD' 不存在！请确保在正确的目录下运行。"
    exit 1
fi

if [ -d "$NEW" ]; then
    echo "❌ 目标目录 '$NEW' 已存在！请先删除它。"
    exit 1
fi

echo "📁 复制 $OLD → $NEW ..."
cp -r "$OLD" "$NEW"

cd "$NEW" || exit 1

# 删除误拷贝过来的旧固件
rm -f *.uf2

echo "📝 暴力重命名并替换所有文件..."
# 1. 把所有名字里带 x18n 的文件重命名为 x200n
for file in *"$OLD"*; do
    if [ -f "$file" ]; then
        newfile="${file//$OLD/$NEW}"
        mv "$file" "$newfile"
    fi
done

# 2. 遍历当前目录下的所有文件，把文件内容里的 x18n 替换成 x200n
# 只处理文本文件（忽略图片等二进制）
find . -type f ! -name "*.uf2" ! -name "*.bin" ! -name "*.png" ! -name "*.jpg" | while read -r file; do
    sed -i "s/${OLD}/${NEW}/g" "$file"
    # 处理大写 (比如 Kconfig.shield 里的 SHIELD_X18N)
    sed -i "s/${OLD^^}/${NEW^^}/g" "$file"
done

echo ""
echo "✅ 新分体键盘 '$NEW' 创建完成！"
echo "📂 位置: $(pwd)"
echo "⚠️  请手动打开 x200n-layouts.dtsi 和 x200n_left/right.overlay，检查并修改引脚（GPIO）配置！"