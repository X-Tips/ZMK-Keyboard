#!/bin/bash
# 用法: 在 Github Codespace 终端运行 bash setup_alias.sh
# 功能: 自动配置 build、push、newkb 和 newsplit 别名

SCRIPT_DIR="$(pwd)"

# 删除旧配置（顺便清理掉之前可能配错的 newkb / newsplit）
sed -i '/alias build=/d' ~/.bashrc 2>/dev/null
sed -i '/alias push=/d' ~/.bashrc 2>/dev/null
sed -i '/alias newkb=/d' ~/.bashrc 2>/dev/null
sed -i '/alias newsplit=/d' ~/.bashrc 2>/dev/null
sed -i '/export PATH=.*ZMK-/d' ~/.bashrc 2>/dev/null

# 写入新配置
echo "alias build=\"$SCRIPT_DIR/build.sh\"" >> ~/.bashrc
echo "alias push=\"cd $SCRIPT_DIR && git add . && git commit -m \\\"Update \$(date +%Y-%m-%d)\\\" && git push origin main --force && rm -rf /workspaces/zmk/app/build_* && rm -rf /home/codespace/.cache/zephyr 2>/dev/null\"" >> ~/.bashrc
echo "alias newkb=\"bash $SCRIPT_DIR/newkb.sh\"" >> ~/.bashrc
echo "alias newsplit=\"bash $SCRIPT_DIR/newsplit.sh\"" >> ~/.bashrc

echo "export PATH=\$PATH:$SCRIPT_DIR" >> ~/.bashrc
source ~/.bashrc

echo "✅ build、push、newkb、newsplit 已全部设置，当前目录: $SCRIPT_DIR"