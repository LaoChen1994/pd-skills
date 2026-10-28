# Node 多场景 Service 用构造器注册表路由

规则描述：多个场景共享调用契约和公共流程、各自有独立实现时，用共同抽象类和场景子类，并建立覆盖全部场景的类型化“场景 → Service 构造器”注册表。入口按已校验的场景选构造器，实例化后调用共同方法；公共流程留在抽象类，差异留在子类。单一场景无需这套结构。适用于 Node 多场景 Service。

不好的写法：入口逐项构造具体 Service。

```ts
if (scene === Scene.Read) return new ReadTaskService(ctx).run(data);
if (scene === Scene.Share) return new ShareTaskService(ctx).run(data);
```

喜欢的写法：

```ts
const services: Record<Scene, new (ctx: Context) => TaskService> = {
    [Scene.Read]: ReadTaskService,
    [Scene.Share]: ShareTaskService,
};

const Service = services[scene];
const result = await new Service(ctx).run(data);
```
