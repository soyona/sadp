#!/bin/bash

# ==============================================================================
# 🚀 Spec-Driven Solo 开发工程规范 (V1.0) - Mac 一键初始化脚本
# 使用方法: 
#   1. sh init_spec_project.sh             (将以当前日期命名创建项目)
#   2. sh init_spec_project.sh my-cool-app (自定义项目名称)
# 
# 赋予权限命令: chmod +x init_spec_project.sh
# ==============================================================================

# 1. 动态获取项目名称
PROJECT_NAME=$1
if [ -z "$PROJECT_NAME" ]; then
    CURRENT_DATE=$(date "+%Y%m%d")
    PROJECT_NAME="spec-app-$CURRENT_DATE"
fi

echo "📂 正在初始化 Spec-Driven V1.0 项目: ${PROJECT_NAME}..."

# 2. 创建项目根目录并进入
mkdir -p "$PROJECT_NAME" && cd "$PROJECT_NAME"

# 3. 创建三大轨道的标准子目录
mkdir -p product-assets/PRD product-assets/wireframes product-assets/research
mkdir -p memory-bank
mkdir -p src/types src/components src/lib

# 4. 写入常驻硬约束（AI 行为紧箍咒与熔断机制）
cat << 'EOF' > .clinerules
# 最高系统指令 (System Rules)
1. 每次对话开始前，必须完整通读 `memory-bank/` 下的所有文件，重建世界观。
2. 严禁改动任何未在 `memory-bank/activeContext.md` 中提及的源码文件。
3. 【强类型契约】：编写任何业务逻辑前，必须严格对齐 `memory-bank/dataModels.md`。
4. 【报错熔断】：一旦你在终端运行编译、构建或 Lint 命令连续失败超过 3 次，你必须立刻停止（Stop）一切 Act 行为，向人类如实报告，严禁盲目猜测修改。
EOF
cp .clinerules .codexrules

# 5. 初始化记忆轨基础模板文件
cat << 'EOF' > memory-bank/projectBrief.md
# 项目总纲 (projectBrief.md)
## 1. 核心愿景与产品定义
[在这里写下你产品的一句话定义]

## 2. 核心范围 (In Scope)
- [ ] 核心功能 1

## 3. 显式非目标与边界 (OUT of Scope)
- [ ] 本版本不进行任何真实云端数据库连接，全部使用本地 Mock。
- [ ] 不接入任何第三方真实支付网关。
EOF

cat << 'EOF' > memory-bank/techContext.md
# 技术栈与依赖约束 (techContext.md)
## 1. 锁死技术栈
- 基础框架: [例如：Vite + React + TypeScript / Next.js]
- 样式表现: Tailwind CSS

## 2. 严禁引入的依赖黑名单 (Negative Constraints)
- 严禁引入外部复杂状态库（如 Redux），仅允许使用 React Context。
- 编译与运行命令: `npm run dev` / `npm run build`
EOF

cat << 'EOF' > memory-bank/systemPatterns.md
# 架构与设计模式 (systemPatterns.md)
## 1. 核心设计模式与目录哲学
- 遵循三轨制职责划分，UI 纯组件与容器组件分离。

## 2. UI 组件嵌套树与关系
[在此记录组件的输入 Props、输出 Events 和副作用约束]
EOF

cat << 'EOF' > memory-bank/dataModels.md
# 数据契约模型 (dataModels.md)
## 1. 核心强类型定义 (TypeScript Interfaces)
```typescript
// 示例契约，开发前请由 ChatGPT 网页端生成并替换
export interface UserMock {
  id: string;
  name: string;
}
```
EOF

cat << 'EOF' > memory-bank/activeContext.md
# 动态上下文 (activeContext.md)
## 当前所处阶段
正在进行项目初始化与脚手架搭建。

## 遇到的技术债与权宜之计 (Blockers & Mitigations)
暂无。
EOF

cat << 'EOF' > memory-bank/progress.md
# 任务进度看板 (progress.md)
## 🚀 开发进度清单
[x] 项目 V1.0 目录架构初始化

[ ] 初始化 package.json 与基础依赖配置

[ ] 按照 dataModels.md 实现 src/types 强类型镜像

[ ] 核心功能迭代开始
EOF


# 6. 创建源码轨的占位文件
touch src/types/index.ts src/main.ts package.json tsconfig.json

echo "--------------------------------------------------------"
echo "✅ [Mac] Spec-Driven V1.0 目录结构一键初始化成功！"
echo "📂 项目路径: $(pwd)"
echo "💡 提示: 请直接使用 VS Code 打开该目录，并将文件夹授权给 Codex/Cline 开始挂机搬砖。"
echo "--------------------------------------------------------"