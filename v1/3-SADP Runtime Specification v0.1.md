# SADP Runtime Specification v0.1

---

# 1. System Overview（系统概述）

## 1.1 目标定义

SADP Runtime Specification 定义一个**面向 Solo AI Software Development 的运行时协作规范**，用于约束 ChatGPT、Codex、Git、CI/CD 在软件研发过程中的行为、状态流转与信息交换方式。

其核心目标：

* 建立统一的 AI 研发运行规则
* 消除跨工具上下文断裂
* 统一状态表达与流转机制
* 将研发过程抽象为可执行协议（非实现系统）

---

## 1.2 系统边界（非常重要）

本规范**不是系统实现**，仅定义：

* 行为规则
* 状态机
* 输入输出契约
* 协作协议
* 生命周期定义

明确禁止：

* 工程实现设计
* API / SDK 设计
* 自动化系统设计
* 运行环境设计
* 代码结构设计

---

## 1.3 系统抽象模型

```text
ChatGPT (Design Runtime)
        ↓
Git (State Runtime)
        ↓
Codex (Execution Runtime)
        ↓
CI/CD (Validation Runtime)
        ↓
Git (State Update)
        ↓
ChatGPT (Iteration)
```

---

# 2. Role Specification（角色定义）

## 2.1 ChatGPT（Design / Decision Role）

### 职责

* 产品定义
* 架构设计
* Task拆解
* 技术决策
* Code Review（逻辑层）

### 输入

* Git 当前状态
* CI 反馈
* Task 状态

### 输出

* Task Specification
* Design Decision Record（DDR）
* Review Result

---

## 2.2 Codex（Execution Role）

### 职责

* 执行单 Task
* 生成代码
* 修复 bug
* 编写测试
* 提交 PR

### 输入

* 单一 Task（不可扩展上下文）
* Task Acceptance Criteria

### 输出

* Code Changes
* Test Results
* PR State Update

---

## 2.3 Git（State Source Role）

### 职责

* 唯一状态源（SSOT）
* 存储所有 Task / Design / Code / Decision
* 维护版本历史

### 表达内容

* Task State
* Design State
* PR State
* Release State

---

## 2.4 CI/CD（Validation Role）

### 职责

* 自动验证系统正确性
* 执行构建/测试
* 输出验证结果

### 输出类型

* PASS
* FAIL
* PARTIAL FAIL (with error trace)

---

# 3. Task Model Specification（任务模型规范）

## 3.1 Task 定义

Task 是 SADP 的**最小执行单位**

```text
Task = 可执行 + 可验证 + 可追踪 + 原子化工作单元
```

---

## 3.2 Task 结构标准

```text
Task := {
  id: TaskID (string, immutable),

  title: string,

  context_ref: GitPointer (required, immutable),

  input: InputSchema,
  output: OutputSchema,

  acceptance_criteria: CriteriaSet,

  dependencies: [TaskID],

  state: TaskState (S0–S9),

  execution_policy: ExecutionPolicy
}
```

### 3.2.1 InputSchema（强约束）

```text
InputSchema := {
  type: "structured",

  required_fields: [string],

  optional_fields: [string],

  constraints: [
    "no external context allowed",
    "must be fully derivable from context_ref"
  ]
}
```

### 3.2.2 OutputSchema（强约束）
```text
OutputSchema := {
  type: "structured",

  required_fields: [string],

  format: "deterministic",

  constraints: [
    "must be machine-parseable",
    "must map to acceptance criteria",
    "no free-form narrative output allowed"
  ]
}
```

### 3.2.3 Acceptance Criteria（形式化升级）
```text
CriteriaSet := [
  Criterion
]
```
Criterion 结构：
```text
Criterion := {
  id: string,

  type: "boolean_assertion",

  condition: Expression,

  expected: boolean
}
```
示例表达（关键）

```text
condition: "CI.status == PASS"
expected: true
```

### 3.2.4 ExecutionPolicy（新增关键约束）
```text
ExecutionPolicy := {
  max_iterations: integer = 3,

  allowed_context: ["context_ref only"],

  forbidden:
    [
      "external assumptions",
      "implicit domain knowledge",
      "cross-task leakage"
    ],

  failure_mode: "must transition to FAILED state"
}
```


🚨 强制约束（Freeze Level Rule）

新增三条协议级 invariant：

- P2-INV-1（Input Determinism）
```text
Task execution input MUST be fully derivable from context_ref
```
- P2-INV-2（Output Determinism）
```text
Output MUST be deterministic for identical input + state
```
- P2-INV-3（No Free Context）
```text
No external or implicit knowledge allowed in execution
```
---

## 3.3 Task 生命周期（State Machine）

```text
FSM: TaskStateMachine (Deterministic)

States:
  S0 = DRAFT
  S1 = READY
  S2 = IN_PROGRESS
  S3 = CODE_COMPLETE
  S4 = CI_RUNNING
  S5 = FAILED
  S6 = FIXING
  S7 = PASSED
  S8 = MERGED
  S9 = RELEASED
```

---

### 3.3.1 State Transition Function（状态转移函数）
T: State × Event → State

允许的唯一转移表（必须严格执行）
```text
DRAFT → READY
READY → IN_PROGRESS
IN_PROGRESS → CODE_COMPLETE
CODE_COMPLETE → CI_RUNNING
CI_RUNNING → PASSED | FAILED

FAILED → FIXING
FIXING → CI_RUNNING

PASSED → MERGED
MERGED → RELEASED
```

❌ 强制约束（Freeze关键）

新增规则：

❌ 禁止跳跃状态（no skip transition）

❌ 禁止回退到非 FIXING 路径

❌ CI_RUNNING 必须是唯一验证入口

❌ MERGED 必须来自 PASSED

❌ RELEASED 必须来自 MERGED

---

## 3.4 状态转移规则

* 状态必须单向推进（禁止跳跃）
* FAILED 必须回退到 FIXING
* MERGED 只能由 PASSED 转换
* RELEASED 只能由 MERGED 转换

---

## 3.5 Task 完成判定标准

Task 仅在以下全部满足时完成：

* CI = PASS
* Acceptance Criteria = 全部满足
* Code Review = Approved
* No unresolved dependency

---

# 4. State Model Specification（状态模型规范）

## 4.1 Git = 唯一状态源

所有状态必须写入 Git：

```text
/.sads/
  tasks/
  design/
  state/
  decisions/
  releases/
```

---

## 4.2 状态表达方式

状态必须是结构化对象：

```text
State {
  entity_id
  type (Task / Design / PR / Release)
  status
  timestamp
  linked_refs[]
}
```

---

## 4.3 状态流转规则

```text
Task State Change
   ↓
Git Commit Required
   ↓
CI Trigger (if code-related)
   ↓
Validation Update
```

---

## 4.4 状态回溯规则

任何状态必须支持：

* 时间回溯（version history）
* Task traceability
* Decision lineage tracking

---

## 4.5 一致性规则

* Git 状态 = 唯一真实状态
* ChatGPT 状态 = 派生状态（不可覆盖 Git）
* CI 状态 = 验证状态（不可修改）

---


# 5. Context Bootstrap Specification（FINAL FREEZE VERSION）

---

# 5. Context Bootstrap Specification（上下文启动规范）

---

## 5.1 Bootstrap 定义（Bootstrap Definition）

```text id="bootstrap_def_v1"
Bootstrap := Deterministic Runtime Context Reconstruction Protocol
```

Bootstrap 的唯一目标：

> 从 GitState 100% 可重复地重建 RuntimeContext（无任何外部依赖）

---

## 5.2 GitState Schema（唯一输入结构）

```text id="git_state_v1"
GitState := {
  project_id: string,

  version: string,

  active_task: TaskID,

  task_states: [
    {
      task_id: TaskID,
      state: TaskState,
      last_update: timestamp
    }
  ],

  design_state: [
    {
      design_id: string,
      version: string,
      status: string
    }
  ],

  ci_state: {
    status: CIStatus,
    last_result: ValidationResult
  },

  release_state: {
    version: string,
    status: string
  },

  last_commit: CommitHash,

  timestamp: ISO8601
}
```

---

## 5.3 Bootstrap Execution Function（核心函数）

```text id="bootstrap_fn_v1"
RuntimeContext = F(GitState)
```

---

## 5.3.1 强制约束（Determinism Rules）

```text id="bootstrap_rules"
RULE 1:
RuntimeContext MUST be derived ONLY from GitState

RULE 2:
No external memory, chat history, or implicit context is allowed

RULE 3:
Same GitState MUST always produce identical RuntimeContext

RULE 4:
Partial or missing GitState is invalid (bootstrap failure)

RULE 5:
Bootstrap MUST NOT infer missing information
```

---

## 5.4 RuntimeContext Schema（执行上下文）

```text id="runtime_context_v1"
RuntimeContext := {
  active_task: {
    task_id: TaskID,
    state: TaskState,
    summary: string,
    context_ref: GitPointer
  },

  system_state: {
    phase: "DESIGN | EXECUTION | VALIDATION | RELEASE",
    ci_status: CIStatus,
    blockers: [string]
  },

  execution_focus: {
    current_goal: string,
    next_action: string
  }
}
```

---

## 5.5 Bootstrap Execution Protocol（执行流程）

```text id="bootstrap_flow_v1"
Step 1: Load GitState
Step 2: Validate GitState Schema
Step 3: Reject if any required field missing
Step 4: Apply F(GitState)
Step 5: Generate RuntimeContext
Step 6: Initialize Runtime Execution Layer
```

---

## 5.6 GitState Validity Rules（新增关键）

```text id="git_validation"
GitState is VALID iff:

- active_task != null
- ci_state.status exists
- last_commit exists
- task_states is not empty
- timestamp is valid ISO8601
```

---

## 5.7 Context Minimality Invariant（强约束）

```text id="minimality_v1"
RuntimeContext MUST satisfy:

- contains ONLY active_task related data
- no historical task expansion
- no full repository snapshot
- no non-relevant design data
- no speculative inference
```

---

## 5.8 Deterministic Guarantee（核心冻结约束）

```text id="determinism_v1"
∀ GitState A, B:

IF A == B THEN F(A) == F(B)
```

---

## 5.9 Bootstrap Failure Model（新增）

```text id="bootstrap_failure"
BootstrapFailure := {
  type: "MISSING_FIELD | INVALID_SCHEMA | INCONSISTENT_STATE",

  behavior: "HALT_RUNTIME",

  recovery: "REQUEST_VALID_GITSTATE"
}
```

---

## 5.10 System Invariants（最终冻结约束）

### INV-BOOT-1（唯一输入源）

```text id="inv_boot_1"
GitState is the ONLY valid input to Bootstrap
```

---

### INV-BOOT-2（无状态运行）

```text id="inv_boot_2"
System MUST be fully reconstructable without runtime memory
```

---

### INV-BOOT-3（严格确定性）

```text id="inv_boot_3"
Bootstrap output MUST be deterministic and repeatable
```

---

### INV-BOOT-4（禁止推断）

```text id="inv_boot_4"
System MUST NOT infer missing state under any condition
```

---

# ✅ 本章节冻结完成定义

当且仅当：

* GitState 可完整恢复系统状态
* RuntimeContext 无任何隐式依赖
* Bootstrap 为纯函数映射
* 无人工解释需求


---

# 6. Execution Protocol（执行协议）

## 6.1 标准执行链路

```text
ChatGPT → Git → Codex → CI → Git → ChatGPT
```

---

## 6.2 输入输出契约

### ChatGPT → Git

输出：

* Task Definition
* Design Decision

---

### Git → Codex

输入：

* Task Object（唯一输入）
* Acceptance Criteria

---

### Codex → Git

输出：

* Code Diff
* Task State Update

---

### CI → Git

输出：

* Validation Result
* Failure Logs

---

### Git → ChatGPT

输入：

* Updated Task State
* CI Status
* Merge Status

---

## 6.3 状态更新规则

每次执行必须产生：

* State Transition
* Git Commit
* Trace Link

---

# 7. Validation Protocol（验证协议）

## 7.1 CI = 唯一裁判

CI := Deterministic Validation Function

CI: (Task, CodeState, TestState) → ValidationResult

---

### 7.1.1 ValidationResult 结构（新增）
ValidationResult := {
  status: CIStatus,

  code: PASS | FAIL,

  test: PASS | FAIL | PARTIAL,

  errors: [ErrorTrace],

  decision: CI_Decision
}
### 7.1.2 CI Decision Model（核心补丁）

CI_Decision := {
  PASS  => ALL_CONDITIONS_TRUE,
  FAIL  => ANY_CONDITION_FALSE,
  PARTIAL_FAIL => RECOVERABLE_FAILURE
}

### 7.1.3 Condition Set（强制判定规则）

CI_Conditions := {
  build: boolean,
  lint: boolean,
  unit_test: boolean,
  integration_test: boolean,
  acceptance_test: boolean
}

决策函数定义（关键）

```text
CI_PASS :=
  build == true AND
  lint == true AND
  unit_test == true AND
  integration_test == true AND
  acceptance_test == true
```

## 7.2 Task 完成判定

```text
Task_PASSED :=
  CI(Task).decision == PASS
  AND Task.acceptance_criteria ALL TRUE
  AND CI.errors == []
```

---

## 7.3 Failure 回流机制

```text
CI FAIL
↓
Task → FAILED
↓
Codex FIXING
↓
重新执行 CI
```

FailureType :=
  - BUILD_ERROR
  - TYPE_ERROR
  - LOGIC_ERROR
  - TEST_FAILURE
  - INTEGRATION_FAILURE
  - ACCEPTANCE_MISMATCH


Failure → State 映射（关键补丁）


IF FailureType ∈ {BUILD_ERROR, TYPE_ERROR}
   → STATE = FAILED

IF FailureType ∈ {TEST_FAILURE, INTEGRATION_FAILURE}
   → STATE = FAILED

IF FailureType == ACCEPTANCE_MISMATCH
   → STATE = FIXING

---

## 7.4 不允许人工判定

禁止：

* 人工判断 Task 完成
* 人工 override CI
* 人工修改状态结果

CI_RUNNING MUST emit exactly one ValidationResult

ValidationResult MUST map to:
  - PASSED
  - FAILED
  - FIXING


强制约束（Freeze Level）

❌ CI 不允许输出模糊状态

❌ CI 不允许无结果返回

❌ CI 不允许人工解释补偿

❌ CI 必须 deterministic

---

# 8. System Constraints（系统约束）

## 8.1 禁止人工状态维护

所有状态必须：

* 自动生成
* Git记录
* CI验证

---

## 8.2 禁止跨工具隐式通信

工具之间只能通过：

* Git State
* Task Object

通信

---

## 8.3 禁止无 Task 执行

Codex 不得执行：

* 非 Task 输入
* 自由开发
* 未定义工作

---

## 8.4 ChatGPT 禁止执行代码

ChatGPT 仅：

* 设计
* 决策
* Review

不参与运行时执行

---

## 8.5 状态唯一性约束

系统中只允许：

* 一个 Task Active State
* 一个 Source of Truth（Git）

---

# 9. Completion Criteria（完成标准）

SADP Runtime Specification v0.1 被视为完整，当满足：

## 9.1 执行一致性

* ChatGPT 可根据规范拆 Task
* Codex 可独立执行 Task
* CI 可验证结果
* Git 可回溯状态

---

## 9.2 闭环完整性

必须覆盖：

```text
Design → Task → Execution → Validation → State Update → Iteration
```

---

## 9.3 可解释性

任何状态必须可以回答：

* 当前在做什么
* 为什么在做这个 Task
* 下一步是什么
* 当前阻塞是什么

---

## 9.4 系统完整闭环

```text
Design (ChatGPT)
  ↓
State (Git)
  ↓
Execution (Codex)
  ↓
Validation (CI)
  ↓
State Update (Git)
  ↓
Next Design (ChatGPT)
```

---

# Final Statement

SADP Runtime Specification v0.1 定义的是一个：

> **以 Git 为状态核心、Task 为执行原子、CI 为验证机制、ChatGPT 为设计引擎、Codex 为执行引擎的 AI Native Software Development Runtime Protocol**

该规范的本质不是系统，而是：

> **一个可执行的软件研发协作状态机协议（Runtime-level Protocol State Machine）**
