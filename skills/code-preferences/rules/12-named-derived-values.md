# 业务派生值移出 JSX

规则描述：有业务含义的派生值在渲染前用具名 `const` 表达，JSX 只引用结果。有实际缓存收益时才用 `useMemo`；不要机械地把所有一次性简单表达式抽出来。适用于 React 组件。

不好的写法：

```tsx
<span>{mobile.replace(/(\d{3})(\d{4})(\d{4})/, '$1****$3')}</span>
```

喜欢的写法：

```tsx
const maskedMobile = mobile.replace(/(\d{3})(\d{4})(\d{4})/, '$1****$3');
return <span>{maskedMobile}</span>;
```
