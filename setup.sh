#!/bin/bash
# 用法: 在Github Codespace终端运行 bash setup.sh （安装过程中有问题咨询ai）
# 功能: 一键配置 ZMK 编译环境（克隆源码 + 安装工具链 + 设置快捷命令）

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=========================================="
echo "🚀 开始配置 ZMK 编译环境"
echo "=========================================="
echo "📂 配置仓库: $SCRIPT_DIR"

# 1. 安装系统依赖
echo ""
echo "📦 安装系统依赖..."
sudo apt update
sudo apt install -y ninja-build protobuf-compiler
echo "✅ 系统依赖安装完成"

# 2. 克隆 ZMK 官方源码
echo ""
echo "📦 克隆 ZMK 源码..."
cd /workspaces
if [ -d "zmk" ]; then
    echo "⚠️ zmk 目录已存在，跳过克隆"
else
    git clone https://github.com/zmkfirmware/zmk.git
    echo "✅ ZMK 源码克隆完成"
fi

# 3. 安装 west
echo ""
echo "📦 安装 west..."
pip install west
echo "✅ west 安装完成"

# 4. 初始化 west 工作区
echo ""
echo "📦 初始化 west 工作区..."
cd /workspaces/zmk
if [ ! -d ".west" ]; then
    west init -l app/
else
    echo "⚠️ west 工作区已存在，跳过 init"
fi
echo "✅ west 工作区初始化完成"

# 5. 更新 west 模块
echo ""
echo "📦 更新 west 模块（可能需要 3-5 分钟）..."
west update
echo "✅ west 更新完成"

# 6. 安装 Python 依赖
echo ""
echo "📦 安装 Python 依赖..."
pip install -r zephyr/scripts/requirements.txt
if [ -f "app/requirements.txt" ]; then
    pip install -r app/requirements.txt
else
    echo "⚠️ app/requirements.txt 不存在，跳过"
fi
pip install protobuf grpcio-tools pyelftools
echo "✅ Python 依赖安装完成"

# 7. 安装 Zephyr SDK
echo ""
echo "📦 安装 Zephyr SDK（可能需要 5-10 分钟）..."
west sdk install
echo "✅ Zephyr SDK 安装完成"

# 8. 给 build.sh 添加可执行权限
chmod +x "$SCRIPT_DIR/build.sh" 2>/dev/null || true

# 9. 设置快捷命令
echo ""
echo "📦 设置快捷命令..."
sed -i '/alias build=/d' ~/.bashrc 2>/dev/null
sed -i '/alias push=/d' ~/.bashrc 2>/dev/null
sed -i '/export PATH=.*ZMK-Keyboard/d' ~/.bashrc 2>/dev/null

echo "alias build=\"$SCRIPT_DIR/build.sh\"" >> ~/.bashrc
echo "alias push=\"cd $SCRIPT_DIR && git add . && git commit -m \\\"Update \$(date +%Y-%m-%d)\\\" && git push origin main && rm -rf /workspaces/zmk/app/build_* && rm -rf /home/codespace/.cache/zephyr 2>/dev/null\"" >> ~/.bashrc
echo "export PATH=\$PATH:$SCRIPT_DIR" >> ~/.bashrc

echo "✅ 快捷命令已添加到 ~/.bashrc"

echo ""
echo "=========================================="
echo "✅ 环境配置完成！"
echo "=========================================="
echo ""
echo "⚠️ 首次使用需手动执行: source ~/.bashrc"
echo ""
echo "💢 可用命令："
echo "   build 键盘名  - 编译固件（如 build x35n）"
echo "   push         - 提交推送到GitHub，同时清理缓存"
echo ""
echo "=========================================="
