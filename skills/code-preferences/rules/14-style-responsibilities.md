# 按样式职责选择位置

规则描述：在同时使用 Tailwind 与 CSS Module 的项目里，常规布局、间距和颜色优先写 Tailwind 类；复杂动画、第三方库内部选择器覆盖放 CSS Module；运行时计算值可用 `style`。沿用项目现有 CSS/SCSS 约定，局部样式留在局部，避免无必要的新样式文件。适用于这类前端项目。

不好的写法：把多条第三方内部选择器硬塞进元素类名。

```tsx
<div className="[&_.picker-item]:px-3 [&_.picker-item:hover]:bg-gray-100 [&_.picker-item_active]:font-bold" />
```

喜欢的写法：

```tsx
<div className={classNames('flex gap-2', styles.picker)} />
```

```css
.picker :global(.picker-item:hover) { background: var(--hover-color); }
```
