# 偏好使用 async/await

规则描述：异步业务流程优先用 `async/await` 表达顺序；需要处理异常时用 `try/catch`。避免把请求、状态更新和异常处理串成 `.then().catch()` 链。能通过异步返回值判断结果并顺序执行的操作，不传入 `onSuccess` 等回调来串联后续业务步骤；异步方法应在其约定的操作完成后返回结果，失败时明确反馈。

不要在流程中间 `await` 一个靠隐藏回调、循环或订阅维持、却没有明确完成与失败出口的 Promise，让调用者不知道停在哪一步。耗时流程使用已有状态提供必要的等待、失败和完成反馈；已有 Hook 或 Store 管理结果时按 [复用已有能力](21-reuse-existing-hooks.md) 消费其状态，不另包一个等待 Promise。通知外部事件的真实 callback 契约仍可保留。适用于可使用 `await` 的 JavaScript/TypeScript 代码。

不好的写法：

```ts
getDocumentInfo()
    .then(setDocumentInfo)
    .catch(() => reportLoadFailure());
```

喜欢的写法：

```ts
try {
    const info = await getDocumentInfo();
    setDocumentInfo(info);
} catch {
    reportLoadFailure();
}
```

以下示例中，保存后必须发布，发布后才能展示完成结果。

不好的写法：`await` 只等待外层调用，后续步骤藏在回调中；调用方无法直接知道整个流程何时完成或失败。

```ts
await saveDocument(values, {
    onSuccess: (document) => {
        publishDocument(document.id, {
            onSuccess: () => setStatus('done'),
        });
    },
});
```

喜欢的写法：每个方法返回其操作结果，后续步骤直接使用结果，等待与失败位置清楚可见。

```ts
const handlePublishClick = async () => {
    try {
        setStatus('saving');
        const document = await saveDocument(values);
        setStatus('publishing');
        await publishDocument(document.id);
        setStatus('done');
    } catch (error) {
        setStatus('failed');
        reportPublishFailure(error);
    }
};
```
