# 避免无必要抽象

规则描述：不为单次使用的简单表达式或 API 调用抽取 helper、闭包、类型别名或配置对象，不增加只转交参数、换名调用的组件或 Hook。新增通用复用 helper 需同时满足：同一逻辑至少有三处调用；输入输出自然且明确；抽取能降低阅读复杂度。

一个几十行的函数混合了多段可独立处理的业务逻辑时，可以按实际职责拆成具名函数，便于单独理解和维护；这种职责拆分不受“三处调用”限制。判断依据是混合职责和阅读复杂度，不是行数本身；不要把每次 API 调用都单独包装成函数。具有业务语义的派生值、框架要求的回调和事件处理函数按对应规则处理；承担实际业务能力的 Hook 与 UI 的职责分离按 [UI 与业务能力分离](20-separate-ui-and-business-logic.md) 执行。适用于所有代码工作。

不好的写法：把只用一次的简单表达式包装成 helper。

```ts
const getDisplayName = (user: User) => user.name.trim();
const displayName = getDisplayName(user);
```

喜欢的写法：直接保留表达式及其业务含义。

```ts
const displayName = user.name.trim();
```

不好的写法：组件增加一层后仍只透传相同 Props。

```tsx
const SaveButton = (props: Props) => <SaveButtonView {...props} />;

const SaveButtonView = ({ onSave }: Props) => (
    <button onClick={onSave}>保存</button>
);
```

喜欢的写法：保留实际渲染按钮的组件。

```tsx
const SaveButton = ({ onSave }: Props) => (
    <button onClick={onSave}>保存</button>
);
```

以下用联系人导入说明长函数的职责拆分，省略与拆分无关的错误展示。`ContactRow` 是输入行，`Contact` 是校验后的联系人。

不好的写法：导入事件里混合逐行校验、数据转换、提交和结果展示。

```ts
const handleImportClick = async () => {
    const contacts: Contact[] = [];
    const seenEmails = new Set<string>();

    for (const [index, row] of rows.entries()) {
        const name = row.name.trim();
        const email = row.email.trim().toLowerCase();
        if (!name || !email) {
            throw new Error(`第 ${index + 1} 行缺少姓名或邮箱`);
        }
        if (seenEmails.has(email)) {
            throw new Error(`第 ${index + 1} 行邮箱重复`);
        }
        seenEmails.add(email);
        contacts.push({ name, email });
    }

    const result = await importContacts(contacts);
    setImportResult(result);
    setSelectedFile(null);
    await reloadContacts();
    showMessage(`已导入 ${result.count} 位联系人`);
};
```

喜欢的写法：把完整的逐行校验与转换作为独立职责；提交和页面动作仍按顺序保留，不再包装每次 API 调用。

```ts
const parseContacts = (rows: ContactRow[]): Contact[] => {
    const contacts: Contact[] = [];
    const seenEmails = new Set<string>();

    for (const [index, row] of rows.entries()) {
        const name = row.name.trim();
        const email = row.email.trim().toLowerCase();
        if (!name || !email) {
            throw new Error(`第 ${index + 1} 行缺少姓名或邮箱`);
        }
        if (seenEmails.has(email)) {
            throw new Error(`第 ${index + 1} 行邮箱重复`);
        }
        seenEmails.add(email);
        contacts.push({ name, email });
    }

    return contacts;
};

const handleImportClick = async () => {
    const contacts = parseContacts(rows);
    const result = await importContacts(contacts);
    setImportResult(result);
    setSelectedFile(null);
    await reloadContacts();
    showMessage(`已导入 ${result.count} 位联系人`);
};
```
