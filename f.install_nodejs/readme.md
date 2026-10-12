# f.install_nodejs — 安装 Node.js（nvm）

在客户机/开发机安装 Node.js（默认 **22.22.0 LTS**），为需要 npm 的工具（如 codex / claude-code 等）提供运行时。

## 用法

```bash
bash f.install_nodejs/run.sh
```

## 说明

- 通过 **nvm** 管理 Node.js 版本，装到 `~/.nvm`（可用 `NVM_DIR` 覆盖）。
- 自动写入 `npmmirror` 镜像加速，下载更快。
- 首次安装 nvm，之后安装/切换 node 版本幂等。

## 环境变量

| 变量 | 默认 | 说明 |
|------|------|------|
| `NODE_VERSION` | `22.22.0` | 要安装的 Node.js 版本 |
| `NVM_DIR` | `~/.nvm` | nvm 安装目录 |

> 依赖网络（github.com / raw.githubusercontent.com / npmmirror.com）。
