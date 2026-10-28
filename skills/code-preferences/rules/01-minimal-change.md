# 只做必要改动

规则描述：只修改请求所需的代码，沿用项目风格。不增加未要求的功能、配置或兼容逻辑，不顺手重构或格式化相邻代码。指定页面或组件的改动优先在该范围完成；只有需求确实涉及公共能力时才修改公共实现，不把局部需求扩散到其他使用方。禁止借局部业务需求顺手修改公共请求或数据方法，尤其不得以假设性的防御增强扩大改动范围；数据返回值按 [必要业务边界与能力支持](26-check-business-boundaries.md) 中的既有契约要求使用。只清理本次修改造成的无用代码；原有无关死代码只需告知用户。业务 MR 不提交开发过程中临时创建的测试脚本或 docs 下的过程说明文件；临时验证在仓库外执行，交付仅保留本次需求必要的业务代码与交付物。不要因此删除已有正式测试或产品文档；需求明确要求交付的正式测试与文档仍按要求保留。适用于所有代码工作。

不好的写法：为一个标题改动顺手改写整个组件。

```tsx
const title = config.title;
const items = oldItems.map(convertItem); // 与标题需求无关的新重构
return <NewLayout title={title} items={items} />;
```

喜欢的写法：只调整标题所需的一行。

```tsx
return <CurrentLayout title={config.title} items={oldItems} />;
```

不好的写法：把一次性验证脚本、开发过程记录和业务改动一起提交。

```text
本次 MR 新增：
  src/reports/create.ts
  report-check.test.mjs       # 临时验证脚本
  docs/report-dev-notes.md     # 开发过程说明
```

喜欢的写法：临时验证留在仓库外，MR 保留必要交付物，不删除原有正式测试和产品文档。

```text
仓库外临时验证：
  /tmp/report-check.mjs

本次 MR 修改：
  src/reports/create.ts
```
