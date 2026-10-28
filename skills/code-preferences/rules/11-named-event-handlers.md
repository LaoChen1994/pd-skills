# 业务事件使用具名处理函数

规则描述：有业务逻辑的按钮事件放在组件作用域的具名函数中；事件处理函数按 `handle` + 业务对象 + 实际动作命名，例如 `handlePanelExpand`。不要把 `expandPanel` 这类操作名直接用于点击处理函数；普通业务操作函数仍可用动作名。名称要对应实际行为：打开保存确认框的点击处理不能叫 `handleSaveSuccess`，尚未保存成功。JSX 和列表渲染回调只引用或传参，不内联业务步骤。事件函数不受通用 helper“三处调用”门槛限制。只有引用稳定性确有作用时才用 `useCallback`。适用于 React 组件。

不好的写法：

```tsx
const expandPanel = () => setExpanded(true);
<button onClick={expandPanel}>展开面板</button>

<button onClick={() => {
    setActiveId(item.id);
    onChange(item.id);
}}>选择</button>
```

喜欢的写法：

```tsx
const handlePanelExpand = () => setExpanded(true);
<button onClick={handlePanelExpand}>展开面板</button>

const handleItemClick = (event: React.MouseEvent<HTMLButtonElement>) => {
    const { value } = event.currentTarget;
    setActiveId(value);
    onChange(value);
};

<button value={item.id} onClick={handleItemClick}>选择</button>
```
