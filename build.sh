#!/bin/bash
# 用法: ./build.sh 键盘名 [-l] [-r]
# 示例: ./build.sh x35n          # 编译支持 Studio 的固件（单体）
# 示例: ./build.sh x18n -l       # 编译左手固件（中央侧，含 Studio）
# 示例: ./build.sh x18n -r       # 编译右手固件（外围侧，自动不含 Studio）

SHIELD_NAME=$1
SIDE=""

# 解析参数
shift  # 移除第一个参数
for arg in "$@"; do
    case "$arg" in
        -l) SIDE="left" ;;
        -r) SIDE="right" ;;
        *)
            echo "错误: 未知参数 $arg"
            echo "用法: ./build.sh 键盘名 [-l|-r]"
            exit 1
            ;;
    esac
done

if [ -z "$SHIELD_NAME" ]; then
    echo "错误: 请指定键盘名"
    echo "用法: ./build.sh 键盘名 [-l|-r]"
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHIELD_PATH="$SCRIPT_DIR/$SHIELD_NAME"
LINK_PATH="/workspaces/zmk/app/boards/shields/$SHIELD_NAME"

# 确定实际编译的 shield 名称
if [ -n "$SIDE" ]; then
    SHIELD_FULL="${SHIELD_NAME}_${SIDE}"
else
    SHIELD_FULL="$SHIELD_NAME"
fi

BUILD_DIR="/workspaces/zmk/app/build_$SHIELD_FULL"

# 确定固件文件名
if [ -n "$SIDE" ]; then
    OUTPUT_NAME="${SHIELD_NAME}-${SIDE}"
else
    OUTPUT_NAME="$SHIELD_NAME"
fi

OUTPUT_FILE="$SHIELD_PATH/${OUTPUT_NAME}.uf2"

# 检查目录
if [ ! -d "$SHIELD_PATH" ]; then
    echo "错误: 找不到键盘文件夹 $SHIELD_PATH"
    exit 1
fi

# 删除旧固件
if [ -f "$OUTPUT_FILE" ]; then
    echo "🗑️ 删除旧固件: $OUTPUT_FILE"
    rm -f "$OUTPUT_FILE"
fi

# 软链接
if [ ! -L "$LINK_PATH" ] && [ ! -d "$LINK_PATH" ]; then
    echo "🔗 创建软链接: $SHIELD_NAME"
    ln -sf "$SHIELD_PATH" "$LINK_PATH"
fi

# 清理缓存
if [ -d "$BUILD_DIR" ]; then
    echo "🧹 清理旧编译缓存: $BUILD_DIR"
    rm -rf "$BUILD_DIR"
fi

# 判断是否启用 Studio
USE_STUDIO=true
if [ "$SIDE" = "right" ]; then
    USE_STUDIO=false
fi

echo ""
echo "=========================================="
if [ "$USE_STUDIO" = true ]; then
    echo "开始编译: $SHIELD_FULL (支持 ZMK Studio)"
else
    echo "开始编译: $SHIELD_FULL (不支持 ZMK Studio)"
fi
echo "=========================================="

cd /workspaces/zmk/app

# 构建编译命令
if [ "$USE_STUDIO" = true ]; then
    # 单体键盘或左手，加 snippet 和 CONFIG_ZMK_STUDIO=y
    west build -d "$BUILD_DIR" -b nrfmicro/nrf52840/zmk -S studio-rpc-usb-uart -- -DSHIELD=$SHIELD_FULL -DCONFIG_ZMK_STUDIO=y
else
    # 右手，不加 snippet 也不加 CONFIG
    west build -d "$BUILD_DIR" -b nrfmicro/nrf52840/zmk -- -DSHIELD=$SHIELD_FULL
fi

if [ $? -ne 0 ]; then
    echo "❌ 编译失败！"
    exit 1
fi

cp "$BUILD_DIR/zephyr/zmk.uf2" "$OUTPUT_FILE"

echo ""
echo "✅ 编译成功！"
echo "📦 固件已保存到: $OUTPUT_FILE"
ls -lh "$OUTPUT_FILE"