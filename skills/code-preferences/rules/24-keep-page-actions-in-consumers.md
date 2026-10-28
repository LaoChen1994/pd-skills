# 页面专属动作留在消费层

规则描述：通用 Hook 提供业务操作和结果；页面跳转、当前场景埋点、关闭当前面板等动作由消费层处理。不为传递页面专属动作增加多层 callback 参数或 Ref 中转。存在真实通用通知契约时仍可使用 callback；需要持久引用时仍可使用 Ref。适用于通用业务 Hook 与具体页面的边界。

以下为文档保存的提炼示例：`useSaveDocument()` 的 `save()` 在保存完成后返回，其职责是保存文档。保存后跳转到哪一页、关闭哪个面板由当前编辑页决定。

不好的写法：为具体编辑页向通用 Hook 透传多种页面动作。

```tsx
const { save } = useSaveDocument({
    onNavigate: () => navigate('/documents'),
    onTrack: () => track('editor_save_success'),
    onClosePanel: () => setPanelOpen(false),
});
```

喜欢的写法：业务 Hook 完成保存，当前页面处理后续动作。

```tsx
const { save } = useSaveDocument();

const handleSaveClick = async () => {
    await save();
    track('editor_save_success');
    setPanelOpen(false);
    navigate('/documents');
};
```
