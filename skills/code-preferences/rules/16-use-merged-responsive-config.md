# 使用已有的响应式合并配置

规则描述：项目已有响应式配置合并结果时，读取合并后的统一字段。不要并行增加设备专属字段，也不要在组件里硬编码兜底文案，除非产品数据契约明确要求。适用于有响应式内容配置的项目。

不好的写法：

```tsx
const title = login.mobileTitle || '默认标题';
const extra = '固定说明';
```

喜欢的写法：

```tsx
const title = login.title;
const extra = login.extra;
```
