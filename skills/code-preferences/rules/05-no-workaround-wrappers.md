# 不用包装或调度掩盖控制流问题

规则描述：不要仅为安放 `await`、绕过类型问题或转移错误处理而引入 IIFE、定义后立即调用的函数或调度器。只有业务确实要求延迟执行、并发隔离或生命周期切换时才使用调度器。React Effect 的异步函数遵从其专门规则。适用于 JavaScript/TypeScript。

不好的写法：

```ts
const run = async () => saveOrder(order);
queueMicrotask(() => run());
```

喜欢的写法：在已有异步流程中直接等待结果。

```ts
await saveOrder(order);
```
