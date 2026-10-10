#!/bin/bash
# 把 ops_develop 打成可分发的离线 tar 包（不含 .git、运行期解压产物）
set -euo pipefail
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd || echo "$PWD")
TOP=$(dirname "$SCRIPT_DIR")
VERSION="${1:-$(cat "$SCRIPT_DIR/VERSION" 2>/dev/null || echo 0.1.0)}"
OUT="$SCRIPT_DIR/dist"
mkdir -p "$OUT"
PKG="$OUT/ops_develop-${VERSION}.tar.gz"

tar -czf "$PKG" \
  -C "$TOP" \
  --exclude='.git' \
  --exclude='.DS_Store' \
  --exclude='__pycache__' \
  --exclude='*.pyc' \
  --exclude='*.log' \
  --exclude='ops_develop/dist' \
  --exclude='ops_develop/d.op_agent/a.install_opencode/opencode' \
  --exclude='ops_develop/d.op_agent/b.skill_store/repo' \
  ops_develop

echo "打包完成: $PKG"
ls -lh "$PKG"
