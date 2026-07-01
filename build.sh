#!/bin/bash
# 用法: ./build.sh 键盘名 [-n]
# 示例: ./build.sh x35n      # 编译支持 ZMK Studio 的固件（默认）
# 示例: ./build.sh x35n -n   # 编译不支持 ZMK Studio 的固件

SHIELD_NAME=$1
NO_STUDIO=false

# 检查是否传入 -n 参数
if [ "$2" = "-n" ]; then
    NO_STUDIO=true
fi

if [ -z "$SHIELD_NAME" ]; then
    echo "错误: 请指定键盘名"
    echo "用法: ./build.sh 键盘名 [-n]"
    echo "示例: ./build.sh x35n"
    echo "示例: ./build.sh x35n -n"
    exit 1
fi

# 获取脚本所在目录（即配置仓库根目录）
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

SHIELD_PATH="$SCRIPT_DIR/$SHIELD_NAME"
LINK_PATH="/workspaces/zmk/app/boards/shields/$SHIELD_NAME"
BUILD_DIR="/workspaces/zmk/app/build_$SHIELD_NAME"

# 根据参数决定文件名后缀
if [ "$NO_STUDIO" = true ]; then
    OUTPUT_FILE="$SHIELD_PATH/${SHIELD_NAME}_no_studio.uf2"
else
    OUTPUT_FILE="$SHIELD_PATH/${SHIELD_NAME}.uf2"
fi

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
if [ "$NO_STUDIO" = true ]; then
    echo "开始编译: $SHIELD_NAME (不含 ZMK Studio 支持)"
else
    echo "开始编译: $SHIELD_NAME (含 ZMK Studio 支持)"
fi
echo "=========================================="

cd /workspaces/zmk/app

# 构建编译命令
if [ "$NO_STUDIO" = true ]; then
    # 不支持 Studio：不加 -S 和 CONFIG_ZMK_STUDIO=y
    west build -d "$BUILD_DIR" -b nrfmicro/nrf52840/zmk -- -DSHIELD=$SHIELD_NAME
else
    # 支持 Studio：加 snippet 和 CONFIG_ZMK_STUDIO=y
    west build -d "$BUILD_DIR" -b nrfmicro/nrf52840/zmk -S studio-rpc-usb-uart -- -DSHIELD=$SHIELD_NAME -DCONFIG_ZMK_STUDIO=y
fi

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