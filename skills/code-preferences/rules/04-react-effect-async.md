# 在 React Effect 中调用独立的异步函数

规则描述：`useEffect` 回调保持同步；需要异步请求时，在独立的 `async` 箭头函数中写顺序流程和异常处理，再从 Effect 调用。不要把 Effect 回调声明为 `async`，也不要在 Effect 内使用 IIFE。适用于 React Effect 中的异步工作。

不好的写法：

```tsx
useEffect(() => {
    getDocumentInfo().then(setDocumentInfo).catch(reportLoadFailure);
}, [status]);
```

喜欢的写法：

```tsx
const loadDocumentInfo = async () => {
    try {
        const info = await getDocumentInfo();
        setDocumentInfo(info);
    } catch {
        reportLoadFailure();
    }
};

useEffect(() => {
    if (status === 'ready') loadDocumentInfo();
}, [status]);
```
