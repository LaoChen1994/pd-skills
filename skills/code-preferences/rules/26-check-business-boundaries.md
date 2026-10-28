# 检查必要的业务边界与能力支持

规则描述：操作前检查实际前置条件，例如必要参数是否为空、当前环境是否支持所需 SDK 能力。SDK 提供 `canIUse()` 等能力判断时优先使用它，条件不满足时明确反馈或沿用项目既有降级方式。复用公共请求或数据方法前，必须先阅读其返回类型、实现与已有调用契约；已有类型或契约可以保证的数据必须直接按契约使用，禁止基于假设追加 `null`、`undefined`、`typeof` 或对象结构等重复防御分支。外部不可信输入仍在必要入口校验，不把本规则泛化为永不校验外部输入。若确有可复现的契约缺陷，先说明复现事实与影响，再按用户明确的任务范围做最小修复。适用于前后端业务代码、公共请求与数据方法调用、外部 SDK 接入。

以下示例中，`documentId` 的类型已确定为 `string`，`exportSDK` 是已初始化且有类型的 SDK，`canIUse('exportDocument')` 表示当前环境是否支持导出。

不好的写法：忽略空 ID 和环境支持，直接调用；或把前置检查扩成重复类型防御。

```ts
const handleExportClick = async () => {
    await exportSDK.exportDocument(documentId);
};

// 已有类型契约，不需要每次调用再检查方法的类型。
if (typeof documentId === 'string'
    && typeof exportSDK === 'object'
    && typeof exportSDK.exportDocument === 'function') {
    await exportSDK.exportDocument(documentId);
}
```

喜欢的写法：只判断真正影响操作的业务条件与能力支持。

```ts
const handleExportClick = async () => {
    if (!documentId.trim()) {
        showMessage('请先选择文档');
        return;
    }
    if (!exportSDK.canIUse('exportDocument')) {
        showMessage('当前环境不支持导出');
        return;
    }

    await exportSDK.exportDocument(documentId);
};
```

以下示例中，项目已有 `requestConfig()` 的返回契约是配置对象或带有 `code`、`msg` 的错误对象，保证返回非空对象。当前任务只是消费配置，不涉及修改这一公共契约。

不好的写法：没有复现到契约缺陷，却在公共方法中增加空值和对象类型兜底。

```ts
const res = await requestConfig(key);
if (res === null || res === undefined
    || (typeof res === 'object' && 'code' in res && 'msg' in res)) {
    return undefined;
}
return res;
```

喜欢的写法：保留原有错误结果判断，直接遵循已有返回契约。

```ts
const res = await requestConfig(key);
if ('code' in res && 'msg' in res) {
    return undefined;
}
return res;
```

## 编码与 Review 的强制检查

- 必须检查 diff 中新增的空值、类型和结构防御分支，确认其依据是实际不可信边界、业务前置条件或可复现的契约缺陷；“可能为空”“保险起见”不是依据。
- 编码交付前必须移除本次引入的无依据重复防御；仅做 Review 时必须将其作为本规则违规项报告，指出返回契约和最小修复方式。
- 必须检查公共请求或数据方法的改动是否属于本次需求；无关防御改动按 [只做必要改动](01-minimal-change.md) 撤回，不顺手清理其他原有代码。

- 必须按 [当前数据契约](17-follow-current-data-contract.md) 检查后续必需且契约允许缺失的对象：条件显式覆盖对象缺失；对象与必需字段缺失走同一异常或返回分支时用短路 OR 合并，不机械拆出重复分支。不同处理语义或实际依赖才分别判断，保留原有业务条件，throw 后不追加 return。
