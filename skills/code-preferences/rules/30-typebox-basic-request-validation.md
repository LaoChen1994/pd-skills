# TypeBox 请求参数默认只校验基础类型

规则描述：服务端请求参数的 TypeBox schema 默认只声明基础类型，例如 `Type.String()`、`Type.Number()`。不要在没有需求或既有接口契约依据时叠加 `minLength`、`maxLength`、`pattern`、`additionalProperties`、数值范围等约束。确有明确要求时保留必要约束，不借此删除既有契约要求的校验。必要的鉴权、权限、启用状态等业务条件仍按现有契约处理；业务边界参照 [检查必要的业务边界与能力支持](26-check-business-boundaries.md)。适用于服务端 TypeBox 请求参数定义。

以下示例中，请求只要求标题为字符串、份数为数字，没有额外的长度、字符范围、数值范围或未知字段限制。

不好的写法：自行增加没有需求依据的约束。

```ts
const CreateReportRequest = Type.Object({
    title: Type.String({
        minLength: 1,
        maxLength: 100,
        pattern: '^[a-zA-Z0-9]+$',
    }),
    copies: Type.Number({ minimum: 1, maximum: 100 }),
}, { additionalProperties: false });
```

喜欢的写法：按实际契约保留基础类型校验。

```ts
const CreateReportRequest = Type.Object({
    title: Type.String(),
    copies: Type.Number(),
});
```
