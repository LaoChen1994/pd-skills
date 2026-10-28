# PD Frontend CR 正反例

## 1. 可信 Props 不重复做运行时校验

不推荐：

```tsx
interface Props {
    initialValue?: { name: string; resourceKey: string };
}

const value = typeof initialValue === 'object'
    && initialValue !== null
    && !Array.isArray(initialValue)
    && typeof initialValue.name === 'string'
    ? initialValue
    : undefined;
```

推荐：

```tsx
const name = initialValue?.name.trim() ?? '';
```

动态 Context 属于不可信边界，可以做一次必要校验：

```tsx
const records = session.context.records;
const savedRecord = Array.isArray(records)
    ? records.find((item) => item?.messageId === message.id)
    : undefined;
```

## 2. 不增加只有透传职责的方法

不推荐：

```tsx
const handleCreateSuccess = async (id: number) => {
    await onSuccess?.({ id });
};

const handleSuccess = async (id: number) => {
    await handleCreateSuccess(id);
};
```

推荐：

```tsx
const handleSuccess = async (id: number) => {
    await onSuccess?.({ id });
};
```

通用复用 helper 需满足三处调用等条件；几十行函数中混杂的独立业务逻辑可以按职责拆分，不把单次 API 调用分别包装。完整边界与示例见 [避免无必要抽象](../../code-preferences/rules/02-avoid-unnecessary-abstraction.md)。

## 3. 接入已有注册表

不推荐：

```tsx
if (type === 'create') {
    return <CreateCard />;
}

const Component = components[type];
return Component ? <Component /> : null;
```

推荐：

```tsx
const components = {
    info: InfoCard,
    tool: ToolCard,
    create: CreateCard,
};

const Component = components[type];
return Component ? <Component /> : null;
```

## 4. 保留已有协议

历史内容使用 `button_text` 时，不要仅为前端命名风格把协议改为 `buttonText`。

推荐在消费边界转换：

```tsx
const { button_text: buttonText } = attributes;
```

## 5. 数据由最小消费范围获取

不推荐：只有一个组件需要消息，却给全部动态组件注入：

```tsx
const Inline = (props: InlineProps) => {
    const message = useContext(MessageContext);
    const Component = components[props.type];

    return <Component {...props} message={message} />;
};
```

推荐由目标组件消费，并把 Provider 放在消息层：

```tsx
const CreateCard = (props: CreateCardProps) => {
    const message = useContext(MessageContext);
};

<MessageContext.Provider value={message}>
    {message.records.map((record) => <Record key={record.id} record={record} />)}
</MessageContext.Provider>
```

`title`、`description` 等明确的父子契约仍应使用 Props。

## 6. API 表达业务意图

不推荐：

```tsx
open({
    closeOnCreated: false,
    skipDefaultRedirect: true,
    keepResultCard: true,
});
```

推荐：

```tsx
open({ autoEnter: false });
```

```tsx
const open = ({ autoEnter = true }: { autoEnter?: boolean }) => {
    // ...
};
```

## 7. 异步流程保持线性

业务步骤使用异步返回值按顺序执行，不靠 `onSuccess` 参数串联。下面的 `onSuccess` 是整个业务操作完成后的对外通知；完整规则见 [async/await](../../code-preferences/rules/03-prefer-async-await.md)。

不推荐：

```tsx
createOrder(values).then((order) => {
    saveOrder(order).then(() => onSuccess?.(order));
}).catch(console.error);
```

推荐：

```tsx
const handleSubmit = async () => {
    try {
        const order = await createOrder(values);
        await saveOrder(order);
        await onSuccess?.(order);
    } catch (error) {
        Sentry.captureException(error);
    }
};
```

## 8. `useMemo` 只用于有意义的派生值

不推荐：

```tsx
const name = useMemo(() => initialValue?.name ?? '', [initialValue?.name]);
```

推荐：

```tsx
const name = initialValue?.name ?? '';
```

多个位置使用的多分支派生结果可以使用：

```tsx
const selectedView = useMemo(() => {
    if (explicitView) return explicitView;
    if (category?.kind === 'collection') return 'collection';
    return defaultView;
}, [category?.kind, defaultView, explicitView]);
```

## 9. 自动流程允许用户接管

不推荐：用户编辑后仍自动提交：

```tsx
useEffect(() => {
    if (name && category) submit();
}, [category, name, submit]);
```

推荐优先复用表单的 dirty 状态：

```tsx
useEffect(() => {
    if (!form.formState.isDirty && autoSubmit && name && category) {
        submit();
    }
}, [autoSubmit, category, form.formState.isDirty, name, submit]);
```

自动定位等辅助能力应在 `finally` 中结束 Loading，并保留手动选择入口。

## 10. Prompt 只描述决策信息

不推荐：

```text
为了给用户带来更专业、更顺畅的服务体验，当用户准备创建资源时，
请结合上下文尽量帮助用户梳理各种信息……
```

推荐：

```text
用户明确要求创建资源时，收集名称和类型；信息完整后调用 prepare，缺失时只追问缺失项。
```

## 11. 工具合并的边界

如果 `prepare` 必然重新请求 `get_options` 的相同数据，且中间没有用户选择，可以合并。

如果第一个工具返回多个方案，需要用户选择后第二个工具才执行有副作用的操作，例如查询航班和购买航班，则不应合并。

## 12. 使用 Tailwind 令牌

不推荐：

```tsx
<div className="w-[317px] rounded-[18px] text-[#3370ff]" />
```

推荐：

```tsx
<div className="w-80 rounded-2xl text-blue-600" />
```

设计无法由现有令牌表达时可以使用任意值，但 Review 应确认它具有明确视觉意义，并且没有在多处重复。

## 13. 验证真实用户链路

只输入一次完整参数不能验证引导流程。应从模糊目标开始：

```text
用户：我想创建一个资源。
系统：逐步询问缺失信息。
用户：修改自动填写的数据。
系统：停止自动推进，允许手动确认。
系统：操作成功并持久化结果。
用户：刷新页面。
系统：恢复结果和后续操作入口。
```

同时验证自动能力失败后的手动路径、重复渲染、新页面打开方式和正式错误日志。
