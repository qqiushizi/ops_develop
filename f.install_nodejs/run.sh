#!/bin/bash
# ============================================================
# 安装 Node.js（nvm 方式，默认 22.22.0 LTS）
# 依赖网络：github.com / raw.githubusercontent.com / npmmirror.com
#
# 用法:
#   bash run.sh
#
# 环境变量:
#   NODE_VERSION   要安装的 Node.js 版本，默认 22.22.0
#   NVM_DIR        nvm 安装目录，默认 ~/.nvm
# ============================================================
set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; RESET='\033[0m'

NODE_VERSION="${NODE_VERSION:-22.22.0}"
NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
MIRROR_LINE='export NVM_NODEJS_ORG_MIRROR=https://npmmirror.com/mirrors/node/'

echo -e "${CYAN}==> 安装 Node.js ${NODE_VERSION}（nvm）${RESET}"

# ---------- 1. 安装 nvm ----------
if [ -s "$NVM_DIR/nvm.sh" ]; then
    echo -e "  ${GREEN}✔ 已检测到 nvm: $NVM_DIR${RESET}"
else
    echo "  == 获取 nvm ..."
    if command -v git >/dev/null 2>&1; then
        git clone --depth 1 https://github.com/nvm-sh/nvm.git "$NVM_DIR"
    else
        echo -e "  ${YELLOW}未找到 git，改用官方 install.sh${RESET}"
        command -v curl >/dev/null 2>&1 || { echo -e "${RED}[ERROR] 缺少 curl${RESET}" >&2; exit 1; }
        curl -o- -L -A "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/120.0.0.0 Safari/537.36" \
            https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
    fi
fi

[ -s "$NVM_DIR/nvm.sh" ] || { echo -e "${RED}[ERROR] nvm 安装失败${RESET}" >&2; exit 1; }

# ---------- 2. 加载 nvm 到当前 shell ----------
export NVM_DIR
. "$NVM_DIR/nvm.sh" --no-use

# ---------- 3. 设置 npmmirror 加速（幂等） ----------
grep -qF "$MIRROR_LINE" "$HOME/.bashrc" 2>/dev/null || echo "$MIRROR_LINE" >> "$HOME/.bashrc"
export NVM_NODEJS_ORG_MIRROR=https://npmmirror.com/mirrors/node/

# ---------- 4. 安装并使用 ----------
nvm install "$NODE_VERSION"
nvm use "$NODE_VERSION"
nvm alias default "$NODE_VERSION"

echo ""
echo -e "${GREEN}✔ Node.js 安装完成${RESET}"
echo -e "  node: $(node -v)"
if command -v npm >/dev/null 2>&1; then
    echo -e "  npm : $(npm -v)"
fi
echo -e "  注意: 新开终端才会自动生效；当前终端可先执行: ${CYAN}. \$NVM_DIR/nvm.sh && nvm use default${RESET}"
