# 以当前数据契约实现分支

规则描述：以实际仍支持的数据字段和场景为准；本次修改涉及的无用分支和字段应删除，不保留无需求依据的兼容兜底。查询必须使用明确约定的键值，不自行补尾斜杠等变体、扩大匹配范围，或增加无需求依据的内容类型白名单。必要的权限、公开范围与其他访问限制必须按现有契约保留。

按接口对空结果的实际约定先判断并提前返回：无记录返回 null/undefined 时用 `if (!page)`，列表保证为数组时用 `if (!items.length)`。空分支必须返回调用方约定的值，例如工具约定的“未找到相关内容。”文本；不能用裸 `return` 将应有结果变成 undefined。Controller 已通过框架写入约定响应后再 return，仍属于按契约返回。

后续流程必须依赖、且类型或接口契约明确允许缺失的对象，判断条件必须显式覆盖对象缺失。对象缺失与必需字段不满足条件对应同一异常或返回语义时，用短路 OR 合并，例如 `if (!user || !user.phoneNumber)`、`if (!config || !config.prompt)`；不要机械拆成两个重复异常分支，也不要用 `!user?.phoneNumber` 这类属性判断隐去对象缺失的处理。父对象与子配置缺失走相同分支时，可先按实际契约使用 `const config = content && content[tool]` 获取配置，再统一判断。不同异常或返回语义、实际依赖要求分步处理时才分别判断；不得为了拆分而新造异常类型或改变原有处理语义。

终止缺失路径后直接访问或解构字段。手机号、启用状态、prompt 等原有业务条件仍需保留，同分支合并不等于删除条件，不同语义的条件不能误合并。`throw` 已终止当前控制流，不再追加无意义的 `return`。合法可选字段或展示兜底仍可使用可选链，例如已确认 user 存在但 profile 可选时，使用 `user.profile?.avatarUrl`。已保证存在的对象不新增重复检查，遵循 [必要业务边界](26-check-business-boundaries.md)。

确认记录或列表存在后，正常路径直接按模型类型访问数据，顺序完成 URL 构造、输出拼接、缓存等步骤；禁止用覆盖整段正常与空结果流程的三元表达式代替提前返回，也禁止在后续输出处反复判断同一 page。简单的值选择仍可使用三元表达式。禁止为已有保证的字段重复添加可选链、默认空字符串或无意义 trim，也不伪造“有结构但无数据”的成功对象。字段确实可空时按其类型与契约处理。

提前返回必须检查对缓存和日志的影响，确保空分支应有的动作已在返回前或已有统一机制中完成；空结果是否缓存、缓存多久遵循当前项目策略，禁止把某个场景“不缓存空结果”推广到所有项目。定位日志按 [Controller 与日志规则](09-controller-destructure.md) 执行。

已有调用方或外部协议确实要求 found 等状态或固定结构时，必须在相应适配层维护，不能直接删字段或改成 null；变更协议须先核实并同步调用方。Controller 正反例见 [线性处理请求](09-controller-destructure.md)，已有返回契约的强制检查见 [业务边界规则](26-check-business-boundaries.md)。适用于前后端业务代码。

不好的写法：数据已统一却仍保留旧平台分支。

```ts
const url = isIOS ? app.ios : isAndroid ? app.android : app.download;
```

喜欢的写法：

```ts
const url = app.download;
```

以下示例中，path 是约定的精确查询键，需求没有限定内容类型；既有权限和公开范围限制应继续保留。

不好的写法：自行增加路径变体和内容类型筛选。

```ts
const page = await ContentModel.findOne({
    where: {
        path: [path, `${path}/`],
        type: ['guide', 'news'],
    },
});
```

喜欢的写法：查询条件只表达已约定的键值。

```ts
const page = await ContentModel.findOne({ where: { path } });
```

以下示例中，正文查询工具的返回契约为字符串，未找到时返回“未找到相关内容。”；page 为对象或 null。本例已明确只缓存成功正文，空结果不缓存，这仅是示例的项目策略。

不好的写法：用三元表达式覆盖整个输出，再次判断 page 才缓存，空结果路径散落在多处。

```ts
const page = await loadPage(url);
const output = page
    ? [page.title, new URL(page.path, origin).toString(), page.content].join('\n')
    : '未找到相关内容。';
if (page) {
    await cache.set(url, output);
}
return output;
```

喜欢的写法：一次处理空结果及对应日志，之后直接构造、缓存并返回正文。

```ts
const page = await loadPage(url);
if (!page) {
    logger.warn({ url }, '正文未找到');
    return '未找到相关内容。';
}
const canonicalUrl = new URL(page.path, origin).toString();
const output = [page.title, canonicalUrl, page.content].join('\n');
await cache.set(url, output);
return output;
```

列表同样先处理一次空结果，再顺序构造输出；返回值和空分支缓存策略仍按具体接口契约。

```ts
const items = await searchDocuments(keyword);
if (!items.length) {
    logger.info({ keyword }, '搜索未命中');
    return '未找到相关内容。';
}
const output = items.map((item) => item.title).join('\n');
return output;
```

以下为报告生成示例：user 和 content 按契约可能不存在。已有约定是“未登录或未绑定手机号”统一抛 Unauthorized，“配置不存在或缺少 prompt”统一抛 NotFound；配置未启用则是独立的 Forbidden。异常类型沿用项目现有定义。

不好的写法：将同一异常分支机械拆开，抛异常后又写 return。

```ts
const user = await loadCurrentUser();
if (!user) {
    throw new UnauthorizedError('请登录并绑定手机号');
    return;
}
if (!user.phoneNumber) {
    throw new UnauthorizedError('请登录并绑定手机号');
}
const content = await loadReportConfigs();
if (!content) {
    throw new NotFoundError('报告配置不可用');
}
const config = content[reportType];
if (!config) {
    throw new NotFoundError('报告配置不可用');
}
if (!config.prompt) {
    throw new NotFoundError('报告配置不可用');
}
if (!config.enabled) {
    throw new ForbiddenError('报告功能未启用');
}
return generateReport({ userId: user.id, prompt: config.prompt });
```

喜欢的写法：用短路 OR 合并同一异常分支，通过后直接访问字段；保留启用状态的独立业务检查。

```ts
const user = await loadCurrentUser();
if (!user || !user.phoneNumber) {
    throw new UnauthorizedError('请登录并绑定手机号');
}
const content = await loadReportConfigs();
const config = content && content[reportType];
if (!config || !config.prompt) {
    throw new NotFoundError('报告配置不可用');
}
const { enabled, prompt } = config;
if (!enabled) {
    throw new ForbiddenError('报告功能未启用');
}
return generateReport({ userId: user.id, prompt });
```
