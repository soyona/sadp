# SADP Repository Layout v0.1

> **Status:** Frozen
>
> **Version:** v0.1
>
> 本文档定义 SADP（Software AI Development Protocol）项目仓库的基础结构与治理规则。
>
> 自 v0.1 起，仓库结构正式冻结。
>
> 后续协议研发默认基于本结构开展。
>
> 除非发现结构性缺陷，否则不得调整仓库结构。
>
> 如未来确需修改，必须通过 ADR，并在下一版本（如 v0.2）实施。

---

# 一、设计目标

SADP 仓库采用"协议规范"与"协议研发"分离的组织方式。

目标：

* 保持协议规范稳定；
* 保留完整设计演进历史；
* 支持 AI 跨会话持续研发；
* 保持与成熟开源项目一致的组织方式。

---

# 二、仓库目录

```text
sadp/
│
├── README.md
├── CHANGELOG.md
├── LICENSE
│
├── spec/
│   ├── SPEC.md
│   │
│   ├── templates/
│   │   ├── PRODUCT.md
│   │   ├── TASKS.md
│   │   └── DECISIONS.md
│   │
│   └── examples/
│       └── todo-app/
│           ├── PRODUCT.md
│           ├── TASKS.md
│           └── DECISIONS.md
│
└── docs/
    ├── governance/
    │   └── repository-layout-v0.1.md
    │
    ├── context/
    │   ├── CURRENT.md
    │   └── GLOSSARY.md
    │
    ├── adr/
    │
    ├── rfcs/
    │
    └── design/
        ├── philosophy.md
        ├── principles.md
        └── terminology.md
```

---

# 三、目录职责

## 根目录

保存项目级信息。

包括：

* README.md
* CHANGELOG.md
* LICENSE

---

## spec/

保存 SADP 正式协议。

属于 SADP 对外发布内容。

包括：

### SPEC.md

SADP 唯一协议规范。

所有模板、示例及未来工具实现均以该规范为准。

### templates/

官方模板。

用于帮助项目快速采用 SADP。

包括：

* PRODUCT.md
* TASKS.md
* DECISIONS.md

### examples/

官方示例。

用于展示 SADP 的实际应用方式。

---

## docs/

保存 SADP 项目研发资产。

用于协议设计、讨论与持续演进。

**docs 中内容不属于 SADP 协议规范。**

---

### docs/governance/

项目治理文档。

负责定义：

* Repository Layout
* 仓库治理规则
* 冻结策略
* 仓库结构变更规则

---

### docs/context/

研发上下文。

用于支持 AI 跨会话研发。

包括：

* 当前研发目标
* 当前任务
* 当前项目状态
* 下一步工作
* 项目术语

该目录仅服务于 SADP 项目研发。

不属于协议规范。

---

### docs/adr/

Architecture Decision Records。

记录已经正式采纳的重要设计决策。

ADR 一经采纳，不应随意修改。

---

### docs/rfcs/

Request For Comments。

用于记录设计提案。

生命周期：

Proposal

↓

Discussion

↓

Accepted / Rejected

Accepted 后，相应内容进入 SPEC。

---

### docs/design/

保存设计理念。

包括：

* 设计哲学
* 核心原则
* 协议边界
* 术语说明

用于回答：

> 为什么这样设计？

---

# 四、协议与研发边界

SADP Repository 分为两个独立部分。

## Protocol Specification

包括：

* spec/
* README.md
* CHANGELOG.md
* LICENSE

这些构成 SADP 对外发布内容。

---

## Protocol Development

包括：

* docs/

这些用于协议研发。

研发资产不是 SADP 协议的一部分。

---

# 五、仓库治理规则

## Repository Layout Freeze

Repository Layout 自 v0.1 起冻结。

允许：

* 更新 SPEC；
* 新增 ADR；
* 新增 RFC；
* 更新 Templates；
* 增加 Examples；
* 更新研发上下文。

原则上不得：

* 新增一级目录；
* 删除一级目录；
* 重命名一级目录；
* 调整目录职责。

---

## Cross-Session Rule

SADP 的唯一长期记忆来源是 Git Repository。

AI 会话开始时，应首先读取项目仓库，而不是依赖历史聊天记录。

推荐读取顺序：

1. README.md
2. docs/context/CURRENT.md
3. spec/SPEC.md
4. 相关 ADR
5. 相关 RFC

仓库中的治理文档优先于 AI 的临时建议。

若仓库治理规则已冻结，AI 不应再次提出目录结构优化建议。

---

## Repository Changes

仓库结构变更属于治理决策。

任何结构调整必须：

* 建立 ADR；
* 说明设计原因；
* 经评审确认；
* 在下一版本实施。

---

# 六、冻结声明

本文档作为 SADP Repository Layout v0.1 的正式基线。

Repository Layout 自本版本起冻结。

后续研发应持续完善：

* SPEC
* Templates
* Examples
* ADR
* RFC

原则上不再讨论仓库目录结构。

下一次 Repository Layout 评审仅允许在 v0.2 或更高版本进行。
