# 动态类名使用 classnames

规则描述：项目已有 `classnames` 时，用它组合静态类、条件类、CSS Module 类和 Tailwind 类；不要用模板字符串拼接条件类。适用于该依赖已存在的前端项目。

不好的写法：

```tsx
<div className={`shrink-0 ${sent ? 'px-6 pt-5' : 'px-4 pt-1'}`} />
```

喜欢的写法：

```tsx
<div className={classNames('shrink-0', sent ? 'px-6 pt-5' : 'px-4 pt-1')} />
```
