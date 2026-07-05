# 技术栈与依赖约束 (techContext.md)
## 1. 锁死技术栈
- 基础框架: [例如：Vite + React + TypeScript / Next.js]
- 样式表现: Tailwind CSS

## 2. 严禁引入的依赖黑名单 (Negative Constraints)
- 严禁引入外部复杂状态库（如 Redux），仅允许使用 React Context。
- 编译与运行命令: `npm run dev` / `npm run build`
