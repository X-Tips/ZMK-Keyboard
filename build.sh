#!/bin/bash
# 用法: ./build.sh 键盘名
# 示例: ./build.sh x35n

SHIELD_NAME=$1

if [ -z "$SHIELD_NAME" ]; then
    echo "错误: 请指定键盘名"
    echo "用法: ./build.sh 键盘名"
    echo "示例: ./build.sh x35n"
    exit 1
fi

# 获取脚本所在目录（即配置仓库根目录）
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

SHIELD_PATH="$SCRIPT_DIR/$SHIELD_NAME"
LINK_PATH="/workspaces/zmk/app/boards/shields/$SHIELD_NAME"
BUILD_DIR="/workspaces/zmk/app/build_$SHIELD_NAME"
OUTPUT_FILE="$SHIELD_PATH/${SHIELD_NAME}.uf2"

if [ ! -d "$SHIELD_PATH" ]; then
    echo "错误: 找不到键盘文件夹 $SHIELD_PATH"
    echo "可用的键盘:"
    ls -d "$SCRIPT_DIR"/*/ 2>/dev/null | xargs -n 1 basename
    exit 1
fi

# 删除旧的固件文件
if [ -f "$OUTPUT_FILE" ]; then
    echo "🗑️ 删除旧固件: $OUTPUT_FILE"
    rm -f "$OUTPUT_FILE"
fi

# 处理软链接
if [ ! -L "$LINK_PATH" ] && [ ! -d "$LINK_PATH" ]; then
    echo "🔗 创建软链接: $SHIELD_NAME"
    ln -sf "$SHIELD_PATH" "$LINK_PATH"
else
    echo "🔗 软链接已存在: $SHIELD_NAME"
fi

# 清理旧的编译缓存
if [ -d "$BUILD_DIR" ]; then
    echo "🧹 清理旧的编译缓存: $BUILD_DIR"
    rm -rf "$BUILD_DIR"
fi

echo ""
echo "=========================================="
echo "开始编译: $SHIELD_NAME"
echo "=========================================="

cd /workspaces/zmk/app
west build -d "$BUILD_DIR" -b nrfmicro/nrf52840/zmk -S studio-rpc-usb-uart -- -DSHIELD=$SHIELD_NAME -DCONFIG_ZMK_STUDIO=y

if [ $? -ne 0 ]; then
    echo ""
    echo "❌ 编译失败！"
    exit 1
fi

# 复制固件到键盘文件夹
cp "$BUILD_DIR/zephyr/zmk.uf2" "$OUTPUT_FILE"

echo ""
echo "=========================================="
echo "✅ 编译成功！"
echo "📦 固件已保存到: $OUTPUT_FILE"
echo "=========================================="

# 显示文件大小
ls -lh "$OUTPUT_FILE"
