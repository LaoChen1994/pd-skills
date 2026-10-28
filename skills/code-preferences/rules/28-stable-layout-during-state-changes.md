# 状态切换时保持布局稳定

规则描述：同一区域在加载、成功、失败或不同操作方式之间切换时，保留共享布局容器，避免因内容高度变化造成按钮、底部区域反复跳动。只为实际需要稳定的区域保留空间，尺寸沿用设计与项目样式令牌，并兼顾小屏布局；不要为所有内容统一硬编码高度。适用于有多种展示状态的面板、弹窗和页面区域。

以下示例中，导出面板的状态区域反复切换，但底部关闭按钮需要保持位置稳定；`export-panel__status` 的最小高度使用设计规定的尺寸。

不好的写法：不同状态直接替换高度不同的内容，底部按钮随之移动。

```tsx
return (
    <section className="export-panel">
        {status === 'loading' ? <Spinner /> : <ExportResult result={result} />}
        <button onClick={handleCloseClick}>关闭</button>
    </section>
);
```

喜欢的写法：保留状态区域容器，在内部切换内容。

```tsx
return (
    <section className="export-panel">
        <div className="export-panel__status">
            {status === 'loading' ? <Spinner /> : <ExportResult result={result} />}
        </div>
        <button onClick={handleCloseClick}>关闭</button>
    </section>
);
```

```css
.export-panel__status {
    min-height: var(--export-status-min-height);
}
```
