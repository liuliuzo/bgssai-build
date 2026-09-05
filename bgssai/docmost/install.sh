#!/bin/sh
# 把 bgssai-build 接到 bgssai-docmost：装 skill、并入 MCP 配置。
#
# 用法（macOS / Linux）：
#   sh bgssai/docmost/install.sh
#
# 脚本可以重复跑：skill 目录覆盖更新，MCP 配置已经有了就不再追加。
set -eu

GROK_HOME_DIR="${GROK_HOME:-$HOME/.grok}"
HERE="$(cd "$(dirname "$0")" && pwd)"

mkdir -p "$GROK_HOME_DIR/skills"

# 1. skill：整目录覆盖。skill 是本仓维护的产物，本地改了也应该被新版盖掉。
rm -rf "$GROK_HOME_DIR/skills/bgssai-design-docs"
cp -R "$HERE/skills/bgssai-design-docs" "$GROK_HOME_DIR/skills/bgssai-design-docs"
echo "已安装 skill: $GROK_HOME_DIR/skills/bgssai-design-docs"

# 2. MCP 配置：追加而不是覆盖。用户的 config.toml 里还有别的东西，
#    整个文件覆盖会把人家的模型设置、其它 MCP server 一起抹掉。
CONFIG="$GROK_HOME_DIR/config.toml"
if [ ! -f "$CONFIG" ]; then
    cp "$HERE/config.toml" "$CONFIG"
    echo "已创建配置: $CONFIG"
elif grep -q '^\[mcp_servers\.bgssai-docmost\]' "$CONFIG"; then
    echo "配置里已有 bgssai-docmost，跳过（要改地址请直接编辑 $CONFIG）"
else
    printf '\n' >> "$CONFIG"
    cat "$HERE/config.toml" >> "$CONFIG"
    echo "已并入配置: $CONFIG"
fi

# 3. 环境变量只提示不代设：这两个值因人而异，脚本替用户猜一个写进去，
#    等到连不上的时候他还得先发现是脚本猜的。
echo ''
echo '还差两个环境变量，设好就能用了：'
echo '  BGSSAI_DOCMOST_URL    docmost 地址，例如 https://doc.bgssai.com'
echo '  BGSSAI_DOCMOST_TOKEN  在 docmost 网页里签发的访问令牌（bgs_doc_ 开头）'
echo ''
echo '当前值：'
echo "  BGSSAI_DOCMOST_URL   = ${BGSSAI_DOCMOST_URL:-(未设置，将回落到 http://127.0.0.1:8080)}"
if [ -n "${BGSSAI_DOCMOST_TOKEN:-}" ]; then
    echo '  BGSSAI_DOCMOST_TOKEN = (已设置)'
else
    echo '  BGSSAI_DOCMOST_TOKEN = (未设置)'
fi
echo ''
echo '永久设置：把下面两行加进 ~/.bashrc 或 ~/.zshrc'
echo '  export BGSSAI_DOCMOST_URL="https://doc.bgssai.com"'
echo '  export BGSSAI_DOCMOST_TOKEN="bgs_doc_..."'
echo ''
echo '设好后重开终端，跑 grok mcp list 应该能看到 bgssai-docmost。'
