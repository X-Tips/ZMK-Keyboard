#!/bin/bash
# 用法: 在Github Codespace终端运行 bash setup_alias.sh
# 功能: 自动配置 build 和 push 别名

SCRIPT_DIR="$(pwd)"

# 删除旧配置
sed -i '/alias build=/d' ~/.bashrc 2>/dev/null
sed -i '/alias push=/d' ~/.bashrc 2>/dev/null
sed -i '/export PATH=.*ZMK-/d' ~/.bashrc 2>/dev/null

# 写入新配置
echo "alias build=\"$SCRIPT_DIR/build.sh\"" >> ~/.bashrc
echo "alias push=\"cd $SCRIPT_DIR && git add . && git commit -m \\\"Update \$(date +%Y-%m-%d)\\\" && git push origin main --force && rm -rf /workspaces/zmk/app/build_* && rm -rf /home/codespace/.cache/zephyr 2>/dev/null\"" >> ~/.bashrc
echo "export PATH=\$PATH:$SCRIPT_DIR" >> ~/.bashrc

source ~/.bashrc

echo "✅ build 和 push 已设置，当前目录: $SCRIPT_DIR"