# UI 与业务能力分离

规则描述：React 组件负责展示和交互；可独立使用的请求、业务状态和操作流程沉淀为业务函数和 Hook，让同一能力可以搭配不同 UI。拆分必须形成真实职责；仅属当前界面的简单展示状态不需要抽成业务 Hook。适用于 React 业务能力与界面的组织。

以下为文件上传的提炼示例，`uploadFile(file)` 是已有的上传请求函数，返回 Promise。

不好的写法：上传组件同时维护网络请求和界面。

```tsx
const UploadButton = ({ file }: { file: File }) => {
    const [loading, setLoading] = useState(false);

    const handleUploadClick = async () => {
        setLoading(true);
        try {
            await uploadFile(file);
        } finally {
            setLoading(false);
        }
    };

    return <button disabled={loading} onClick={handleUploadClick}>上传</button>;
};
```

喜欢的写法：Hook 提供上传能力，组件决定如何展示。

```tsx
const useFileUpload = () => {
    const [loading, setLoading] = useState(false);

    const upload = async (file: File) => {
        setLoading(true);
        try {
            await uploadFile(file);
        } finally {
            setLoading(false);
        }
    };

    return { upload, loading };
};

const UploadButton = ({ file }: { file: File }) => {
    const { upload, loading } = useFileUpload();
    const handleUploadClick = () => upload(file);

    return <button disabled={loading} onClick={handleUploadClick}>上传</button>;
};
```
