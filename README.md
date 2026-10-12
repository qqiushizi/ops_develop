# ops_develop — 昇腾算子开发工作流（独立工具）

面向昇腾客户机的算子开发一站式工具：**拉镜像建容器 → 容器内环境检查 → 配置 OpenCode → 装运行时与 Skill → 补装缺失环境**。

> 本仓库从 `itool` 的 `d.ops_develop/` 抽出，作为**独立工具**打包使用；原 `itool` 仓库保持不变。

## 目录

```text
ops_develop/
├── a.llm_api/                ① 配置 OpenCode 的 API（baseURL / apiKey / model / provider）
├── b.image_container/        ② 镜像拉取 + 容器实例化（quay.io/ascend/vllm-ascend）
├── c.env_check/              ③ 容器内环境检查（只读，芯片型号 + 版本兼容矩阵 + 建议）
├── d.op_agent/               ④ OpenCode 运行时 + 昇腾官方 Skill 管理
│   ├── a.install_opencode/       安装 opencode 绿色版（内置 CANNBot 1.1.0）
│   ├── b.skill_store/            离线 Skill 仓库（选装/卸载）
│   └── c.update_skill/           联网更新 skill 仓库（可选）
├── e.install_ascend/         环境组件安装（docker/python/cann/torch/gcc/mamba/triton/tilelang）
├── f.install_nodejs/         安装 Node.js（nvm，默认 22.22.0 LTS）
├── workspace/                统一输出目录（脚本生成物默认归档于此）
├── VERSION                   版本号
└── pack.sh                   打包成可分发 tar.gz
```

## 快速开始

```bash
# 进入工具目录，打开可视化文件夹导航（等价于原来的 itool.sh）
cd ops_develop
./opsdevelop.sh
```

也可以不用可视化界面，直接逐项执行：

```bash
# ① 配置 OpenCode 的 API
bash a.llm_api/run.sh

# ② 拉镜像 + 建容器（自动生成 start_container.sh）
bash b.image_container/run.sh

# 进入容器
docker exec -it asc_dev bash
cd /workspace/ops_develop

# ③ 容器内环境检查（只读，给结论与建议；可跳转安装缺失环境）
bash c.env_check/run.sh

# ④ 安装 OpenCode 运行时 + 选装 Skill
bash d.op_agent/a.install_opencode/run.sh      # 安装 opencode 绿色版
bash d.op_agent/b.skill_store/run.sh           # 离线选装 Skill
bash d.op_agent/c.update_skill/run.sh          # 联网更新 skill 仓库（可选）

# 需要 npm 工具时安装 Node.js（默认 22.22.0 LTS）
bash f.install_nodejs/run.sh
```

## 打包分发

```bash
bash pack.sh            # 生成 dist/ops_develop-0.1.0.tar.gz
bash pack.sh 0.2.0      # 指定版本号
```

打包产物分发到客户机后，解压即可原地运行（脚本全部为 bash，兼容 bash 3.2，无第三方依赖）。

## 说明

- 所有脚本纯 bash + 标准命令，面向昇腾客户机（Linux，bash 3.2）。
- `workspace/` 默认被 Git 忽略，客户机生成物不会提交。
- `c.env_check` 只做只读检查；检查结束后可跳转到 `e.install_ascend` 补装缺失组件。
- `d.op_agent` 自带 opencode 绿色版（内置 CANNBot 1.1.0：74 skill + 18 agent），skill 按需加载、不显式弹列表。
- 两个大件 `d.op_agent/a.install_opencode/opencode.tar.gz`、`d.op_agent/b.skill_store/skills.tar.gz` 为离线包，无需联网即可用。
