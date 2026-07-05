#!/bin/bash

# ==============================================================================
# 🌟 Spec-Driven Solo 开源仓库本地一键初始化脚本 (GitHub Prep Script)
# 使用方法:
#   1. 在本地创建一个全新空白目录 (如: mkdir spec-driven-solo && cd spec-driven-solo)
#   2. 将本脚本保存为 init_github_repo.sh
#   3. 运行: sh init_github_repo.sh
# ==============================================================================

# ✍️ 配置区：请在此处填入你的 GitHub 用户名
GITHUB_USERNAME="soyona"

echo "🚀 开始在本地构建 Spec-Driven Solo 开源仓库生态..."

# 1. 创建 GitHub 规范化目录结构
mkdir -p template/memory-bank
mkdir -p docs

# 2. 写入开源许可证 (MIT LICENSE)
cat << EOF > LICENSE
MIT License

Copyright (c) $(date "+%Y") $GITHUB_USERNAME

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to do its sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to the
following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOF

# 3. 写入 .gitignore
cat << 'EOF' > .gitignore
.DS_Store
node_modules/
dist/
build/
.env
*.log
EOF

# 4. 写入分发版一键初始化脚本 (用户可通过 curl 直接运行此文件)
cat << 'EOF' > init_spec.sh
#!/bin/bash

# ==============================================================================
# 🚀 Spec-Driven Solo 开发工程规范 (V1.0) - Mac 一键初始化脚本
# ==============================================================================

PROJECT_NAME=$1
if [ -z "$PROJECT_NAME" ]; then
    CURRENT_DATE=$(date "+%Y%m%d")
    PROJECT_NAME="spec-app-$CURRENT_DATE"
fi

echo "📂 正在初始化 Spec-Driven V1.0 项目: ${PROJECT_NAME}..."

mkdir -p "$PROJECT_NAME" && cd "$PROJECT_NAME"

mkdir -p product-assets/PRD product-assets/wireframes product-assets/research
mkdir -p memory-bank
mkdir -p src/types src/components src/lib

cat << 'INNER_EOF' > .clinerules
# 最高系统指令 (System Rules)
1. 每次对话开始前，必须完整通读 `memory-bank/` 下的所有文件，重建世界观。
2. 严禁改动任何未在 `memory-bank/activeContext.md` 中提及的源码文件。
3. 【强类型契约】：编写任何业务逻辑前，必须严格对齐 `memory-bank/dataModels.md`。
4. 【报错熔断】：一旦你在终端运行编译、构建或 Lint 命令连续失败超过 3 次，你必须立刻停止（Stop）一切 Act 行为，向人类如实报告，严禁盲目猜测修改。
INNER_EOF
cp .clinerules .codexrules

cat << 'INNER_EOF' > memory-bank/projectBrief.md
# 项目总纲 (projectBrief.md)
## 1. 核心愿景与产品定义
[在这里写下你产品的一句话定义]

## 2. 核心范围 (In Scope)
- [ ] 核心功能 1

## 3. 显式非目标与边界 (OUT of Scope)
- [ ] 本版本不进行 any 真实云端数据库连接，全部使用本地 Mock。
- [ ] 不接入 any 第三方真实支付网关。
INNER_EOF

cat << 'INNER_EOF' > memory-bank/techContext.md
# 技术栈与依赖约束 (techContext.md)
## 1. 锁死技术栈
- 基础框架: [例如：Vite + React + TypeScript / Next.js]
- 样式表现: Tailwind CSS

## 2. 严禁引入的依赖黑名单 (Negative Constraints)
- 严禁引入外部复杂状态库（如 Redux），仅允许使用 React Context。
- 编译与运行命令: `npm run dev` / `npm run build`
INNER_EOF

cat << 'INNER_EOF' > memory-bank/systemPatterns.md
# 架构与设计模式 (systemPatterns.md)
## 1. 核心设计模式与目录哲学
- 遵循三轨制职责划分，UI 纯组件与容器组件分离。

## 2. UI 组件嵌套树与关系
[在此记录组件的输入 Props、输出 Events 和副作用约束]
INNER_EOF

cat << 'INNER_EOF' > memory-bank/dataModels.md
# 数据契约模型 (dataModels.md)
## 1. 核心强类型定义 (TypeScript Interfaces)
```typescript
// 示例契约，开发前请由 ChatGPT 网页端生成并替换
export interface UserMock {
  id: string;
  name: string;
}

```

INNER_EOF

cat << 'INNER_EOF' > memory-bank/activeContext.md

# 动态上下文 (activeContext.md)

## 当前所处阶段

正在进行项目初始化与脚手架搭建。

## 遇到的技术债与权宜之计 (Blockers & Mitigations)

暂无。
INNER_EOF

cat << 'INNER_EOF' > memory-bank/progress.md

# 任务进度看板 (progress.md)

## 🚀 开发进度清单

* [x] 项目 V1.0 目录架构初始化
* [ ] 初始化 package.json 与基础依赖配置
* [ ] 按照 dataModels.md 实现 src/types 强类型镜像
* [ ] 核心功能迭代开始
INNER_EOF

touch src/types/index.ts src/main.ts package.json tsconfig.json

echo "--------------------------------------------------------"
echo "✅ [Mac] Spec-Driven V1.0 目录结构一键初始化成功！"
echo "📂 项目路径: $(pwd)"
echo "💡 提示: 请直接使用 VS Code 打开该目录，并将文件夹授权给 Codex/Cline 开始挂机搬砖。"
echo "--------------------------------------------------------"
EOF

# 5. 🛠️ 修复核心：安全、原位提取纯净模板至 template/ 目录

echo "📦 正在提取无损规范模板..."
cp init_spec.sh template/init_spec_project.sh
(cd template && sh init_spec_project.sh template_holder > /dev/null) # 使用小括号开启沙盒，避免污染全局路径
mv template/template_holder/memory-bank/* template/memory-bank/
mv template/template_holder/.clinerules template/.clinerules
mv template/template_holder/.codexrules template/.codexrules
rm -rf template/template_holder template/init_spec_project.sh

# 6. 自动搬运核心规范文档到 docs/ 目录

echo "📖 正在写入《1-Spec-Driven Solo 开发工程规范 V1.0.md》..."
cat << 'EOF' > docs/1-engineering-spec.md

# 这里放你之前审核完美的：1-Spec-Driven Solo 开发工程规范 V1.0_4.md 内容

EOF

echo "📖 正在写入《2-Spec-Driven Solo 新手入门指南 V1.0.md》..."
cat << 'EOF' > docs/2-beginner-guide.md

# 这里放你之前审核完美的：2.Spec-Driven Solo 新手入门指南 V1.0_2.md 内容

EOF

# 7. Git 仓库初始化预备

git init
git add .
git commit -m "feat: init Spec-Driven Solo repository structures 🎉"

echo "--------------------------------------------------------"
echo "✅ 本地 GitHub 仓库环境及模板备货成功！"
echo "📂 下一步行动指示："
echo "  1. 打开 docs/ 目录下的两份 .md，把对应规范的完整文本贴进去替换占位符。"
echo "  2. 接下来，我们需要编写核心的 README.md 门面文档。"
echo "--------------------------------------------------------"

```
