# 默认禁用 AbortController

规则描述：在用户项目的业务代码、自有 SDK 和请求封装中，默认不新增 `AbortController` 及配套的 `signal`、`abort()` 取消逻辑。请求超时、组件卸载、避免旧结果覆盖、第三方示例使用了取消机制，都不是可以自行放宽该限制的理由。也不要改用 `AbortSignal.timeout()` 等方式绕过限制。

需要超时时，先检查并复用项目请求封装已有的超时能力。封装缺少能力时，先说明缺口及最小处理方案；确实必须引入取消机制时，说明必要性、替代方案和影响，并取得用户明确同意后再使用。仅有“检测需要超时”的需求，不等于用户已批准使用 AbortController。不因本规则顺手改动已有底层实现或第三方依赖。

页面关闭、滑走或组件卸载后，如果结果回来已不影响业务，无需增加取消逻辑。存在旧结果覆盖新结果的问题时，优先复用已有 Hook 或 Store 的结果管理机制。适用于前后端请求、SDK 探测和组件生命周期。

不好的写法：仅凭需要两秒超时，就在业务请求中自行创建取消控制器。

```ts
const controller = new AbortController();
const timer = setTimeout(() => controller.abort(), 2000);
try {
    return await request(url, { signal: controller.signal });
} finally {
    clearTimeout(timer);
}
```

喜欢的写法：先读项目封装；若它已提供 timeout 选项，直接按其真实契约使用，不另加取消控制器。以下选项仅适用于已支持该参数的封装，不得假定所有项目都支持。

```ts
const result = await request(url, { timeout: 2000 });
```

不需要取消的预加载继续沿用已有能力：

```tsx
useEffect(() => {
    warmProductCache(productId);
}, [productId]);
```
