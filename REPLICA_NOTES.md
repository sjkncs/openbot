# 复刻说明（REPLICA NOTES）

本仓库是 **[meetopenbot/openbot](https://github.com/meetopenbot/openbot)** 的**代码复刻镜像**，
由 `sjkncs` 维护。**不是上游官方仓库**，也不代表上游认可。

- 上游许可：**MIT**（见 `LICENSE`，版权归上游作者所有，未改动）
- 复刻方式：`git clone --depth 1`（浅克隆）
- 对源码的改动：**无**。仅追加本文件、`docs/index.html`（GitHub Pages 说明页）与 `docs/.nojekyll`

---

## ⚠️ 两件必须说清的事

### 1. 这不是静态网站，GitHub Pages 放不了它

OpenBot 是 **local-first 的 Node 服务**：

| 事实 | 出处 |
|---|---|
| 监听端口 **4132**，启动打印 `OpenBot server listening at http://localhost:4132` | `src/app/server.ts:552-553` |
| 暴露事件 API，并用 **Server-Sent Events** 流式推送 | `README.md` |
| 数据写入 `~/.openbot`（channels / threads / agents / plugins / config） | `README.md` |
| 入口是 CLI：`openbot start`（`bin: ./dist/app/cli.js`） | `package.json` |

因此 `docs/index.html` **只是项目说明页**，不是可运行的应用。
要真正使用，必须在本地启动服务。

### 2. 本地运行**未实测**（磁盘不足）

```bash
git clone https://github.com/sjkncs/openbot.git
cd openbot
pnpm install     # 约 200–500 MB
pnpm build
pnpm start       # → http://localhost:4132
```

- 本机环境满足前置条件：**Node v22.21.0**（要求 ≥20.12.0）、`pnpm` 可用
- 但复刻时本机磁盘仅剩约 **0.07 GB**，依赖装不下，因此
  **`pnpm install` / `pnpm build` / `pnpm start` 均未实际执行，未验证能跑通**
- 上面的命令取自上游 `README.md` 与 `package.json` 的 `scripts`，未做改动

---

## 复刻清单

| 项 | 状态 |
|---|---|
| 源码完整克隆 | ✅ |
| `LICENSE` 保留（MIT） | ✅ |
| 上游来源与许可在 README / 本文件写明 | ✅ |
| `docs/index.html` 静态说明页 | ✅ |
| GitHub Pages 指向 `docs/` | ✅ |
| `pnpm install` 实测 | ❌ 未做（磁盘不足） |
| 公网托管运行 | ❌ 未做（该工具读写本地 `~/.openbot`，公网托管会改变其存储与鉴权模型） |

## 上游同步

```bash
git remote add upstream https://github.com/meetopenbot/openbot.git
git fetch upstream --depth 1
git merge upstream/main
```
