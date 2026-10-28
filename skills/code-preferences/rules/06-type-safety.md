# 不用类型断言绕过类型问题

规则描述：优先用类型收窄、类型守卫、字面量联合、泛型约束或有类型的映射表达实际数据关系。不要用 `as any` 等断言压制类型错误；确需不常见变通方案时先说明并询问用户。类型定义放在使用处附近，适合时优先箭头函数。适用于 TypeScript。

不好的写法：

```ts
const message = (error as any).message;
```

喜欢的写法：

```ts
const message = error instanceof Error ? error.message : String(error);
```
