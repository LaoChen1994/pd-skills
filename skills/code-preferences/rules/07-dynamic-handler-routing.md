# 同形 handler 使用动态路由

规则描述：同一入口按已验证或已类型化的业务类型分发给多个同形 handler 时，优先用类型化映射动态查找，避免逐项 `if/else`。HTTP 或 DOM 字符串须先校验。只有命名规则稳定、调用上下文明确且类型可自然表达时，才动态拼接方法名；不用断言掩盖索引问题。适用于多类型 handler 分发。

不好的写法：

```ts
if (type === 'read') await handleRead(data);
else if (type === 'share') await handleShare(data);
```

喜欢的写法：

```ts
const handlers: Record<Scene, (data: TaskData) => Promise<void>> = {
    read: handleRead,
    share: handleShare,
};

await handlers[type](data); // type 已是 Scene
```
