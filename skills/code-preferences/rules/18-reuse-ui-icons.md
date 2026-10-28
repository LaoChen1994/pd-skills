# 复用已有 UI 和图标组件

规则描述：界面需要图标或控件时，优先使用项目已有组件，不用文字字符模拟已有图标。适用于前端 UI 开发。

不好的写法：

```tsx
<button aria-label="返回">‹</button>
```

喜欢的写法：

```tsx
<button aria-label="返回"><ChevronLeft /></button>
```
