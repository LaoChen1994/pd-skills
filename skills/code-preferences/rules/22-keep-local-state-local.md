# 少量局部状态直接放在 Hook 或组件中

规则描述：状态仅属于当前组件或 Hook 实例、随组件销毁时，优先使用本地 state。引入 Store 应有跨组件共享、独立生命周期等实际依据；不为几个简单状态默认增加 Store。适用于 React 状态归属。

以下为单个面板的提炼示例：展开状态只供这个面板使用，没有其它组件消费它。反例中的 `PanelStore` 和 `usePanelStore` 表示额外引入的外部状态管理层。

不好的写法：仅为一个面板的展开状态创建外部 Store。

```tsx
const panelStore = new PanelStore({ expanded: false });

const Panel = () => {
    const { expanded } = usePanelStore(panelStore);
    const handlePanelExpand = () => panelStore.setExpanded(true);

    return <PanelContent expanded={expanded} onExpand={handlePanelExpand} />;
};
```

喜欢的写法：让展开状态随当前面板实例管理。

```tsx
const Panel = () => {
    const [expanded, setExpanded] = useState(false);
    const handlePanelExpand = () => setExpanded(true);

    return <PanelContent expanded={expanded} onExpand={handlePanelExpand} />;
};
```
