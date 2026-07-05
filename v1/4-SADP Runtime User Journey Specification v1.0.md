# SADP Runtime User Journey Specification v1.0

## Frozen State Machine Contract（不可扩展执行版）

---

# 0. Scope（范围定义）

本规范定义：

> SADP Runtime System 在真实运行时的**用户旅程 + 状态机 + 执行契约**

---

# 1. System Boundary（系统边界）

## 1.1 系统组成

仅包含：

* ChatGPT（Design Agent）
* Codex（Execution Agent）
* CI/CD（Validation Agent）
* Git（State Store）

---

## 1.2 单一事实源

```text
Git = ONLY Source of Truth
```

---

## 1.3 禁止范围

系统不包含：

* 记忆系统
* 对话历史依赖
* 非 Git 状态
* 隐式上下文
* 自由执行逻辑

---

# 2. User Entry Point（用户入口）

## 2.1 唯一入口行为

```text
User Goal Input
```

示例：

```text
Build a product X
```

---

## 2.2 系统必须执行

```text
Bootstrap → GitState → RuntimeContext
```

---

# 3. Runtime Bootstrap Contract（强约束）

## 3.1 输入

```text
GitState ONLY
```

---

## 3.2 函数定义

```text
RuntimeContext = F(GitState)
```

---

## 3.3 禁止行为

* 不允许使用历史对话
* 不允许推断缺失信息
* 不允许外部输入补全状态

---

## 3.4 输出结构

```yaml
SYSTEM_STATE:
  phase: INIT | DESIGN | EXECUTION | CI | FIXING | RELEASE
  active_task: TaskID | null
  next_action: string
```

---

# 4. State Machine Definition（核心状态机）

## 4.1 状态全集

```text
S0 = INIT
S1 = DESIGN
S2 = TASK_READY
S3 = EXECUTION
S4 = CI_RUNNING
S5 = FAILED
S6 = FIXING
S7 = PASSED
S8 = MERGED
S9 = RELEASED
```

---

## 4.2 状态流转规则（严格）

```text
INIT → DESIGN
DESIGN → TASK_READY
TASK_READY → EXECUTION
EXECUTION → CI_RUNNING

CI_RUNNING → PASSED | FAILED

FAILED → FIXING
FIXING → CI_RUNNING

PASSED → MERGED
MERGED → RELEASED

RELEASED → DESIGN (LOOP)
```

---

## 4.3 禁止流转规则

```text
❌ skip state transition
❌ backward except FIXING loop
❌ parallel states
❌ manual state override
```

---

# 5. Role Execution Contract（角色执行契约）

---

## 5.1 ChatGPT（Design Agent）

### 输入

```text
GitState
CI Result
Task State
```

### 输出

```text
- PRD
- Architecture
- Task Graph
- Acceptance Criteria
```

### 禁止

```text
❌ code generation
❌ execution
❌ task completion marking
```

---

## 5.2 Codex（Execution Agent）

### 输入

```text
Single Task ONLY
+ Acceptance Criteria
+ context_ref
```

### 输出

```text
- Code Diff
- Test Cases
- Pull Request
```

### 禁止

```text
❌ multi-task execution
❌ context expansion
❌ design decisions
```

---

## 5.3 CI（Validation Agent）

### 输入

```text
Code + Tests + Task Criteria
```

### 输出（唯一合法）

```text
PASS | FAIL | FIXING
```

---

## 5.4 Git（State Agent）

### 职责

* Store state
* Track transitions
* Persist tasks

### 数据结构

```json
State {
  entity_id
  type
  status
  timestamp
  refs
}
```

---

# 6. Task Contract（核心执行单元）

---

## 6.1 Task 定义

```text
Task = Atomic Execution Unit
```

---

## 6.2 Task结构

```json
{
  "id": "Tn",
  "title": "",
  "context_ref": "git_pointer",
  "input": {},
  "output": {},
  "acceptance_criteria": [],
  "state": "S1-S9"
}
```

---

## 6.3 Task输入约束

```text
ONLY context_ref allowed
NO external knowledge allowed
NO cross-task dependency inference
```

---

## 6.4 Task输出约束

```text
deterministic
machine-readable
mapped to acceptance criteria
```

---

## 6.5 完成条件

```text
CI == PASS
AND acceptance_criteria == TRUE
AND PR merged
```

---

# 7. Execution Flow（执行流程）

---

## 7.1 标准执行链

```text
User Goal
→ ChatGPT Design
→ Git Task Creation
→ Codex Execution
→ CI Validation
→ Git Update
→ ChatGPT Next Cycle
```

---

## 7.2 单 Task执行流程

```text
1. Git loads Task
2. Codex executes Task
3. CI validates
4. Git updates state
```

---

## 7.3 固定循环

```text
while project not released:
    execute Task
```

---

# 8. CI Validation Contract（验证契约）

---

## 8.1 输入

```text
Build
Test
Acceptance Criteria
```

---

## 8.2 输出

```text
PASS
FAIL
FIXING
```

---

## 8.3 判定逻辑

```text
PASS =
  build == true AND
  lint == true AND
  unit_test == true AND
  integration_test == true AND
  acceptance_test == true
```

---

## 8.4 状态映射

```text
PASS → PASSED
FAIL → FAILED
ACCEPTANCE_MISMATCH → FIXING
```

---

## 8.5 禁止

```text
❌ fuzzy result
❌ partial explanation as output
❌ human override
```

---

# 9. Failure Recovery Contract（失败恢复）

---

## 9.1 失败状态流转

```text
FAILED → FIXING → CI_RUNNING
```

---

## 9.2 FIXING输入

```text
error_trace ONLY
```

---

## 9.3 FIXING禁止

```text
❌ redesign task
❌ change acceptance criteria
❌ expand scope
```

---

# 10. Git State Contract（状态契约）

---

## 10.1 唯一真相源

```text
GitState = Truth
```

---

## 10.2 必须记录

* Task State
* Design State
* CI State
* Release State

---

## 10.3 不允许

```text
❌ ephemeral state
❌ runtime-only memory
❌ agent-local state
```

---

# 11. Bootstrap Failure Contract（失败处理）

---

## 11.1 Failure条件

```text
missing field
invalid schema
inconsistent state
```

---

## 11.2 行为

```text
HALT_RUNTIME
REQUEST_VALID_GITSTATE
```

---

## 11.3 禁止

```text
❌ inference recovery
❌ partial boot
❌ fallback memory
```

---

# 12. Completion Contract（完成标准）

---

系统完成条件：

```text
ALL Tasks PASSED
AND all merged
AND release created
```

---

# 13. Final Frozen Invariants（冻结不变量）

---

## INV-1（唯一状态源）

```text
Git is the only state source
```

---

## INV-2（唯一执行单位）

```text
Task is the only execution unit
```

---

## INV-3（唯一验证系统）

```text
CI is the only validator
```

---

## INV-4（无记忆系统）

```text
No runtime memory exists
```

---

## INV-5（确定性）

```text
Same GitState → Same RuntimeContext
```

---

## INV-6（无自由扩展）

```text
No new states or transitions allowed
```

---

# 14. Final Definition（冻结定义）

> SADP Runtime User Journey v1.0 is a deterministic state machine contract that defines how ChatGPT, Codex, Git, and CI collaboratively execute software development for a solo developer, with Git as the single source of truth and Task as the only execution unit.

---

# END OF SPEC（FROZEN）
