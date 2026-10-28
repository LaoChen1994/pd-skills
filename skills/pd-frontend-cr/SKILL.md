---
name: pd-frontend-cr
description: 在所有项目的前端编写、修改、重构和 Code Review 中自动使用 PD 的工程规范，检查过度抽象、重复防御、数据归属、既有机制复用、异步流程、样式令牌、Prompt 和真实业务链路。
---

# PD Frontend CR

这是个人级前端工程规范，适用于所有项目。编写、修改或重构前端代码时，必须遵守下面的核心检查项，并读取 [references/examples.md](references/examples.md) 中的正反例；根据项目已有技术栈应用相应规则。

用户请求 Code Review 时，只审查用户要求的范围；除非用户明确要求修复，否则输出问题和建议，不直接修改代码。

## Review 流程

1. 确认目标分支和对比分支；未指定时根据仓库默认分支选择 `main` 或 `master`。
2. 阅读完整分支 diff、相关源码、调用点和项目已有实现，不只审查最后一次提交。
3. 先判断改动是否必要，再判断实现是否正确。发现已有注册表、Context、公共 API 或同类流程时，优先建议复用。
4. 只报告可执行且能说明实际影响的问题。不要把个人风格、理论风险或未发生的扩展需求写成缺陷。
5. Findings 按严重程度排序，给出具体文件和行号；没有问题时明确说明，并列出仍未覆盖的验证范围。

## 核心检查项

### UI、业务能力和状态归属

编写和审查 React 代码时，读取并遵守以下个人规则；具体描述和通用正反例统一维护在 `code-preferences/rules/`：

- [UI 与业务能力分离](../code-preferences/rules/20-separate-ui-and-business-logic.md)。
- [优先复用已有的完整能力](../code-preferences/rules/21-reuse-existing-hooks.md)。
- [避免只有透传职责的中间层](../code-preferences/rules/02-avoid-unnecessary-abstraction.md)。
- [少量局部状态直接放在 Hook 或组件中](../code-preferences/rules/22-keep-local-state-local.md)。
- [交互流程由 Hook 编排](../code-preferences/rules/23-orchestrate-interactions-in-hooks.md)。
- [页面专属动作留在消费层](../code-preferences/rules/24-keep-page-actions-in-consumers.md)。

### 最小实现

- 按 [避免无必要抽象](../code-preferences/rules/02-avoid-unnecessary-abstraction.md) 判断方法、变量、配置、类型和状态包装；具有实际业务职责的 Hook 与 UI 分离不因单处使用而被否定。
- 拦截方法 A 只调用方法 B、多个 Boolean 拼成状态机、为未来场景预留扩展点。
- 通用复用 helper 需满足三处调用、自然的输入输出与阅读复杂度下降；长函数混合独立业务职责时可按职责拆分，不把每次 API 调用单独包装。
- 按 [只做必要改动](../code-preferences/rules/01-minimal-change.md) 控制影响范围，局部需求不默认扩散到公共组件。

### 类型与数据边界

- Props、模块内部对象和已通过 Schema 校验的数据按静态类型使用，不重复判断 `object`、数组和字段类型。
- 接口响应、JSON、会话 Context、Markdown 属性、URL 参数和用户输入在进入业务代码的边界校验一次。
- 不要在每个消费点重复完整结构校验，也不要用类型断言绕过类型问题。
- 必须读取并执行 [必要业务边界与能力支持](../code-preferences/rules/26-check-business-boundaries.md) 的强制检查：遵循公共请求与数据方法的既有返回契约，禁止基于假设追加空值、类型和结构防御；实际业务前置条件、SDK 能力与不可信入口仍按需校验。

### 数据归属

- 明确父子契约使用 Props；单组件数据留在组件内部；同一业务范围的深层共享数据复用已有 Context。
- Provider 放在能够表达数据生命周期的最小公共层。
- 不要因为一个组件需要数据，就给全部动态组件增加 Props；也不要为少传一次 Props 创建全局 Context。

### 复用既有机制

- 新类型应接入已有注册表、映射表和动态渲染机制，避免新增 `hasXxx` 或平行分支。
- 保留已有字段、序列化格式和协议；没有业务原因时，不制造相对目标分支的格式改动。
- 优先复用项目的打开页面、错误上报、状态更新和数据请求能力。

### API 与控制流

- 参数应直接表达业务意图，并由默认值描述通用行为。
- 回调负责通知外部；组件自身动作由组件内部逻辑和明确参数控制。
- 按 [当前数据契约](../code-preferences/rules/17-follow-current-data-contract.md) 检查空结果提前返回、协议返回值及缓存和日志影响；正常路径直接使用已确认的数据，不用整段三元表达式或重复空值判断拆散流程。
- 派生值简单时直接计算；复杂、多处使用或需要稳定引用时再考虑 `useMemo`。
- 按 [async/await 与顺序执行](../code-preferences/rules/03-prefer-async-await.md) 直接消费异步结果，不通过 `onSuccess` 串联能顺序执行的步骤，不让流程陷入缺少完成、失败出口和反馈的 Promise 等待。
- 按 [请求必须使用项目已有封装](../code-preferences/rules/29-use-project-request-client.md) 检查请求调用；业务代码和自有 SDK 不绕过已有封装使用原生 fetch，跨域探测也不例外。
- 按 [默认禁用 AbortController](../code-preferences/rules/25-no-default-request-abort.md) 检查取消逻辑；不得以超时或组件卸载为由自行引入，确需使用时先取得用户明确同意。
- 按 [具名事件处理](../code-preferences/rules/11-named-event-handlers.md) 命名，函数名称要对应实际动作。
- 按 [埋点字段复用与确认](../code-preferences/rules/27-confirm-analytics-field-changes.md) 处理埋点，新增字段或复用语义不明确时与用户确认。
- 需要观察的异常使用项目已有 Sentry 或日志服务，不以 `console.error` 代替。按 [日志规则](../code-preferences/rules/09-controller-destructure.md) 保留具体异常和必要查询上下文；不只记录固定失败文案、cache=miss 或耗时，不随意记录敏感请求体。

### 自动流程与持久化

- 自动预填、定位、提交和跳转必须有触发条件、停止条件、失败降级和用户接管路径。
- 用户主动编辑后，不应继续按照旧的自动流程推进。
- 自动能力失败时不得永久阻塞手动操作或保持无限 Loading。
- 刷新后仍需展示的结果必须进入后端或会话持久化结构，不应只保存在组件 State。

### Prompt 与工具

- Prompt 只保留触发条件、动作、缺失信息处理、禁止行为和输出格式。
- 删除不影响模型决策的背景、宣传文案和重复规则。
- 组件格式集中维护在应用 Context；工具说明主要描述调用条件和输入输出。
- 两个工具之间没有用户决策，且后一个工具必然重复前一个工具的数据请求时，建议合并；存在用户选择或明确副作用时保持拆分。

### 样式

- 优先使用项目 Tailwind 配置中的颜色、尺寸、间距、圆角和阴影。
- 对能由现有令牌表达的样式，指出任意值滥用。
- 同时检查 hover、active、disabled、loading、focus 和小屏布局。
- 按 [状态切换时保持布局稳定](../code-preferences/rules/28-stable-layout-during-state-changes.md) 检查实际存在内容跳动的区域。

### 验证

- 不只验证一次性提供完整参数的理想路径。
- 根据改动检查模糊入口、逐步引导、用户编辑、自动能力失败、成功结果、后续操作和刷新恢复。
- 检查 TypeScript、ESLint、`git diff --check` 和目标分支完整 diff；确认没有无关依赖、锁文件或 changeset。

## 输出要求

每条 finding 应包含：

- 严重级别和简短标题。
- 具体文件与最小行号范围。
- 当前代码会造成的实际问题。
- 最小修复方式；存在合理取舍时说明边界。

不要为没有实际影响的命名、格式和个人偏好留下 finding。

需要判断具体写法时，读取 [references/examples.md](references/examples.md)。
