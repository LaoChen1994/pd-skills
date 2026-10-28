# Controller 校验后解构，按线性流程处理请求

规则描述：服务端 Controller 校验 `query`、`body` 或 `params` 后，先解构实际要用的字段，再进入业务逻辑；不要反复读取 `body.xxx` 等属性。简单查询按“基础参数校验和解构 → 必要转换 → 查询 → 空结果提前返回 → 组装响应”线性执行；转换职责按 [请求封装规则](29-use-project-request-client.md) 核实，不为凑齐步骤增加转换或 helper。空记录和响应字段按 [当前数据契约](17-follow-current-data-contract.md) 处理，不另造不需要的状态协议或逐字段兜底。

项目框架已有日志作用域、SQL 日志和日期 JSON 序列化能力时必须直接复用：例如用 `ctx.logger.create('ReportController.getDetail')` 创建作用域，将 `logger.sql` 交给 ORM；日志使用框架已有方法，不自建平行日志结构或手工包装 SQL 日志。响应日期可按模型字段直接传给已有序列化层，不额外做没有契约意义的格式转换。项目另有日期格式或日志格式要求时遵循其契约。

空结果日志必须能定位查询：搜索未命中记录查询关键词，不能只记 cache=miss 或耗时；URL 正文未找到使用 warn 并记录对应 URL。catch 日志必须按项目 logger 的错误记录方式保留具体异常信息，例如 message、stack，不能只有固定失败文案。日志上下文遵守已有脱敏规范，不随意记录完整请求体、凭证或其他敏感数据。适用于服务端 Controller；空结果和异常日志要求同样适用于 Service 与工具适配层。

以下是框架接口示意：`DetailValidator(ctx)` 校验并返回 query；模型保证记录中的 title、content 是字符串，updatedAt 是 Date；框架负责日期 JSON 序列化。接口已约定查不到时返回 null，调用方支持该结果。

不好的写法：反复读取 query，另建 found 协议，对已经由模型保证的字段反复兜底，并手工包装 SQL 日志和日期转换。

```ts
const { query } = ReportController.DetailValidator(ctx);
const report = await ReportModel.findOne({
    where: { id: query.id },
    logging: (sql) => ctx.logger.info(JSON.stringify({ sql, id: query.id })),
});
ctx.success({
    found: !!report?.content?.trim(),
    id: report?.id || query.id,
    title: report?.title || '',
    content: report?.content?.trim() ? report.content : '',
    updatedAt: report?.updatedAt?.toISOString() || null,
});
```

喜欢的写法：校验后解构，复用日志与序列化能力，一次处理空记录，再直接访问模型字段。

```ts
const { query } = ReportController.DetailValidator(ctx);
const { id } = query;
const logger = ctx.logger.create('ReportController.getDetail');
const report = await ReportModel.findOne({
    where: { id },
    logging: logger.sql,
});
if (!report) {
    ctx.success(null);
    return;
}
ctx.success({
    id: report.id,
    title: report.title,
    content: report.content,
    updatedAt: report.updatedAt,
});
```

以下为日志接口示意：已有 logger 支持结构化上下文，并通过 err 字段序列化异常的 message、stack；error 是 catch 捕获到的异常。实际参数形式与脱敏规则以项目封装为准。

不好的写法：知道未命中或失败，但无法定位查询或异常原因。

```ts
logger.info({ cache: 'miss', elapsedMs }, '搜索未命中');
logger.warn('正文未找到');
logger.error('搜索失败');
```

喜欢的写法：空结果记录定位信息，异常日志保留原始异常及必要业务上下文。

```ts
logger.info({ keyword }, '搜索未命中');
logger.warn({ url }, '正文未找到');
logger.error({ err: error, keyword }, '搜索失败');
```
