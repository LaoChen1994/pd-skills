# 优先复用已有的完整能力

规则描述：项目已有 Hook 或 Store 管理数据请求、状态更新和生命周期时，新组件优先消费它的接口，不绕开它重复实现底层请求、轮询、订阅或清理。已有结果状态能表达进度和完成时，直接消费状态，不重新订阅并包装 Promise 等待同一结果。先阅读既有能力，只有真实缺口才增加必要实现。适用于接入项目现有业务能力。

以下为购物车的提炼示例：项目已有 `useCart()`，负责购物车加载、状态更新，并返回 `items`、`loading` 和 `reload`。`fetchCart()` 是其内部使用的底层请求函数。

不好的写法：新组件又维护一份购物车状态和刷新请求。

```tsx
const CartPanel = () => {
    const [items, setItems] = useState<CartItem[]>([]);

    const handleRefreshClick = async () => {
        const items = await fetchCart();
        setItems(items);
    };

    return <CartList items={items} onRefresh={handleRefreshClick} />;
};
```

喜欢的写法：直接消费已有 Hook，沿用它维护的状态和生命周期。

```tsx
const CartPanel = () => {
    const { items, loading, reload } = useCart();

    return <CartList items={items} loading={loading} onRefresh={reload} />;
};
```

以下示例中，`useUpload()` 已负责上传并返回 `status`，`uploadStore` 是它内部使用的状态源。

不好的写法：上传后再订阅同一状态源，另造一个等待结束的 Promise，还容易漏掉失败出口。

```tsx
const { start } = useUpload();

const handleUploadClick = async () => {
    start();
    await new Promise<void>((resolve) => {
        const unsubscribe = uploadStore.subscribe(() => {
            if (uploadStore.status === 'done') {
                unsubscribe();
                resolve();
            }
        });
    });
};
```

喜欢的写法：直接通过已有 Hook 的状态展示结果。

```tsx
const { start, status } = useUpload();

return (
    <>
        <button onClick={start}>上传</button>
        <UploadStatus status={status} />
    </>
);
```
