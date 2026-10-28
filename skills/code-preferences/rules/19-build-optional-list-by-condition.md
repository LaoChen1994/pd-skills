# 按条件逐项构造可选列表

规则描述：构造一组按各自条件展示的 tag、菜单项或操作项时，先加入必选项，再按展示条件逐项 `push`。不要先创建完整长列表、给每项塞入 `isHide`，最后再过滤；这样展示条件与条目本身分开，也便于日后按需抽离某一项的判断。按 `push` 顺序保持预期展示顺序。`inactive` 等可见项自身的状态仍留在条目中。适用于手写的多条件可选展示列表，不替代对已有数据集合的正常筛选。

不好的写法：

```ts
const tags = [
    { key: 'profile', asset: profileAsset },
    { key: 'verified', asset: verifiedAsset, inactive: !isVerified, isHide: !showVerified },
    { key: 'history', asset: historyAsset, isHide: !showHistory },
].filter((tag) => !tag.isHide);
```

喜欢的写法：

```ts
const tags: PanelHeaderTag[] = [
    { key: 'profile', asset: profileAsset },
];

if (showVerified) {
    tags.push({ key: 'verified', asset: verifiedAsset, inactive: !isVerified });
}

if (showHistory) {
    tags.push({ key: 'history', asset: historyAsset });
}
```
