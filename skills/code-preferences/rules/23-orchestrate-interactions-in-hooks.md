# 交互流程由 Hook 编排

规则描述：React 业务 Hook 协调当前交互，Store 维护其拥有的数据、订阅和底层操作。不为了一个界面流程，让 Store 同时控制弹窗、提示和页面跳转，也不向新 Store 透传另一个 Store 来搬运流程。适用于 React Hook 与 Store 的职责划分；已有 Store 的独立业务职责仍可保留。

以下为后台导出的提炼示例：`createExportTask()` 创建任务并返回任务 ID；已有 `exportStore.createTask()` 封装此请求和任务数据管理。

不好的写法：Store 同时承担页面专属交互。

```ts
class ExportStore {
    async run() {
        closeSettingsDialog();
        const task = await createExportTask();
        showToast('开始导出');
        navigate(`/exports/${task.id}`);
    }
}
```

喜欢的写法：Hook 复用 Store 的底层能力并维护当前交互状态，界面消费结果。

```tsx
const useExport = () => {
    const [taskId, setTaskId] = useState<string>();

    const start = async () => {
        const task = await exportStore.createTask();
        setTaskId(task.id);
    };

    return { start, taskId };
};
```
