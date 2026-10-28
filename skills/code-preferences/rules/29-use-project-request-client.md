# 请求必须使用项目已有封装

规则描述：项目或业务已有 fetch、request 等请求封装时，业务代码和自有 SDK 必须使用该封装，不直接调用 `window.fetch`、`globalThis.fetch` 或未导入业务封装的原生 `fetch`。实现前先搜索并阅读封装、类型定义和已有调用点，确认参数传递、编码与解码、响应解析、域名处理及超时能力。输入格式转换必须由约定的负责层执行一次；请求封装已编码、框架已解析的参数，不在业务层重复 encode、decode、trim 或其他规范化。只有业务参数自身存在独立编码契约且默认链路尚未处理时，才在明确负责层补充必要转换；不得将某次 decodeURIComponent 写成所有 query 都必须手工解码的规则。

跨域探测、`no-cors`、读取原始响应等需求也必须先核实现有选项，不能据此自行绕过封装。能力确有缺口时，说明问题并提出封装内的最小补充方案；未经用户明确同意，不退回原生请求或另建一套请求封装。项目没有请求封装，或正在实现请求封装底层、维护第三方依赖时，不机械套用业务层禁用原生请求的要求。适用于前后端业务请求和 SDK 接入。

以下导入路径仅为示意，实际项目使用其已有请求封装。

不好的写法：已有业务 fetch，仍在 SDK 中直接使用浏览器原生接口。

```ts
const response = await window.fetch(url, options);
```

喜欢的写法：导入业务 fetch，按已确认的封装契约传递参数和处理结果。

```ts
import { fetch } from '@/utils/request';

const result = await fetch(url, options);
```

以下是接口示意：项目的 request.get 通过 query 选项自动编码，服务端框架解析后返回原始路径字符串；该参数没有额外的业务编码协议。

不好的写法：请求封装和框架已负责传输编解码，业务层又补一套转换。

```ts
// 调用方
await request.get('/documents/detail', {
    query: { path: encodeURIComponent(documentPath) },
});

// Controller：框架已解析 query。
const { path } = query;
const documentPath = decodeURIComponent(path);
```

喜欢的写法：调用方传原始值，Controller 直接使用框架解析后的值。

```ts
// 调用方
await request.get('/documents/detail', {
    query: { path: documentPath },
});

// Controller
const { path: documentPath } = query;
```
