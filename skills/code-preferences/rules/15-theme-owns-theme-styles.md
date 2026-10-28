# 主题样式由主题定义维护

规则描述：已有稳定的主题命名协议时，按主题名索引样式；主题专属规则放在该主题样式定义里。不要在组件中重复枚举主题，或再拼接主题特例类名。适用于有主题系统的前端组件。

不好的写法：

```tsx
className={classNames(
    theme === 'square' ? styles['theme-square'] : styles['theme-underline'],
    theme === 'square' && 'border-gray-200',
)}
```

喜欢的写法：

```tsx
className={styles[`theme-${theme}`]}
```

```css
.theme-square { border: 1px solid var(--captcha-border-color); }
```
