#!/bin/bash

# 用法: bash newkb.sh <源键盘> <新键盘>
# 示例: bash newkb.sh p61n p32n

OLD=$1
NEW=$2

if [ -z "$OLD" ] || [ -z "$NEW" ]; then
    echo "用法: bash newkb.sh <源键盘名> <新键盘名>"
    echo "示例: bash newkb.sh p61n p32n"
    exit 1
fi

# 检查源目录是否存在
if [ ! -d "$OLD" ]; then
    echo "❌ 源键盘目录 '$OLD' 不存在！"
    exit 1
fi

# 检查新目录是否已存在
if [ -d "$NEW" ]; then
    echo "❌ 目标目录 '$NEW' 已存在！请先删除或改名。"
    exit 1
fi

echo "📁 复制 $OLD → $NEW ..."
cp -r "$OLD" "$NEW"

cd "$NEW" || exit 1

echo "📝 重命名文件..."
# 重命名所有以 OLD 开头的文件
for file in "$OLD".*; do
    if [ -f "$file" ]; then
        newfile="${file/$OLD/$NEW}"
        mv "$file" "$newfile"
        echo "  $file → $newfile"
    fi
done

# 处理 .zmk.yml
if [ -f "$OLD.zmk.yml" ]; then
    mv "$OLD.zmk.yml" "$NEW.zmk.yml"
    echo "  $OLD.zmk.yml → $NEW.zmk.yml"
fi

echo "✏️ 替换文件内容..."

# 1. 替换 .yml 中的 id 和 name
if [ -f "$NEW.yml" ]; then
    sed -i "s/id: $OLD/id: $NEW/g" "$NEW.yml"
    sed -i "s/name: .*/name: \"$NEW Keyboard\"/g" "$NEW.yml"
    echo "  ✅ $NEW.yml"
fi

# 2. 替换 .zmk.yml 中的 id 和 name
if [ -f "$NEW.zmk.yml" ]; then
    sed -i "s/id: $OLD/id: $NEW/g" "$NEW.zmk.yml"
    sed -i "s/name: .*/name: \"$NEW Keyboard\"/g" "$NEW.zmk.yml"
    echo "  ✅ $NEW.zmk.yml"
fi

# 3. 替换 Kconfig.shield
if [ -f "Kconfig.shield" ]; then
    sed -i "s/SHIELD_${OLD^^}/SHIELD_${NEW^^}/g" Kconfig.shield
    sed -i "s/SHIELD_${OLD}/SHIELD_${NEW}/gI" Kconfig.shield
    sed -i "s/\$(shields_list_contains,$OLD)/\$(shields_list_contains,$NEW)/g" Kconfig.shield
    echo "  ✅ Kconfig.shield"
fi

# 4. 替换 Kconfig.defconfig
if [ -f "Kconfig.defconfig" ]; then
    # 替换 SHIELD_xxx（大小写不敏感）
    sed -i "s/SHIELD_${OLD^^}/SHIELD_${NEW^^}/g" Kconfig.defconfig
    sed -i "s/SHIELD_${OLD}/SHIELD_${NEW}/gI" Kconfig.defconfig
    # 替换键盘名称：格式为 "X.p61n Keyboard" → "X.p32n Keyboard"
    sed -i "s/default \"X\.${OLD} Keyboard\"/default \"X.${NEW} Keyboard\"/g" Kconfig.defconfig
    echo "  ✅ Kconfig.defconfig"
fi

# 5. 替换 .overlay 中的 display-name
if [ -f "$NEW.overlay" ]; then
    # 格式：display-name = "X.Tips p61n"; → display-name = "X.Tips p32n";
    sed -i "s/display-name = \"X\.Tips ${OLD}\"/display-name = \"X.Tips ${NEW}\"/g" "$NEW.overlay"
    echo "  ✅ $NEW.overlay"
fi

# 6. 替换 layouts.dtsi 中的 display-name
if [ -f "layouts.dtsi" ]; then
    # 格式：display-name = "X.Tips p61n"; → display-name = "X.Tips p32n";
    sed -i "s/display-name = \"X\.Tips ${OLD}\"/display-name = \"X.Tips ${NEW}\"/g" layouts.dtsi
    echo "  ✅ layouts.dtsi"
fi

# 7. 替换 .conf 文件
if [ -f "$NEW.conf" ]; then
    sed -i "s/CONFIG_ZMK_KEYBOARD_NAME=\".*\"/CONFIG_ZMK_KEYBOARD_NAME=\"X.${NEW} Keyboard\"/g" "$NEW.conf"
    echo "  ✅ $NEW.conf"
fi

echo ""
echo "✅ 新键盘 '$NEW' 创建完成！"
echo "📂 位置: $(pwd)"
echo ""