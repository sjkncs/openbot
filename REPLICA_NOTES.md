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

### 2. 本机未装依赖，但**已在 CI 实测跑通**

```bash
git clone https://github.com/sjkncs/openbot.git
cd openbot
pnpm install     # 约 200–500 MB
pnpm build
pnpm start       # → http://localhost:4132
```

- 本机环境满足前置条件：**Node v22.21.0**（要求 ≥20.12.0）、`pnpm` 可用
- 但本机磁盘严重不足（C 0.035 GB / F 0.359 GB），且 **F、G 为 FAT32——
  不支持硬链接与符号链接，`pnpm` 的 store 机制在此退化甚至失败**，
  因此**未在本机安装依赖**

**改用 GitHub Actions 云端 runner 实测，结果如下：**

| 步骤 | 结果 |
|---|---|
| runner Node | `v22.23.3` |
| `pnpm install --no-frozen-lockfile` | ✅ 通过 |
| `pnpm build` | ✅ 通过，产出 `dist/app/cli.js` |
| `node dist/app/cli.js start` | ✅ 服务启动 |
| HTTP 探测 `http://127.0.0.1:4132/` | ✅ **有响应**：`HTTP/1.1 404 Not Found`、`Content-Type: text/html; charset=utf-8` |

> 根路径 **404 是预期的**：OpenBot 暴露的是**事件 API**，不是带首页的网站。
> 关键证据是它**确实监听 4132 并对 HTTP 作出响应**（不是连接被拒）。
> 证据来源：CI 运行 **38921858721**（`success`，47s）。

**为何用 `--no-frozen-lockfile`**：上游 `pnpm-lock.yaml` 与 `package.json` 不一致——
lockfile 多出 `@anthropic-ai/claude-agent-sdk`、`js-yaml`、`@types/js-yaml` 三个 specifier，
故 `--frozen-lockfile`（CI 默认）必然报 `ERR_PNPM_OUTDATED_LOCKFILE`。
**这是上游问题，非本次复刻引入。**

---

## 复刻清单

| 项 | 状态 |
|---|---|
| 源码完整克隆（192 提交） | ✅ |
| `LICENSE` 保留（MIT，版权归上游） | ✅ |
| 上游来源与许可在 README / 落地页 / 本文件写明 | ✅ |
| `docs/index.html` 静态说明页 | ✅ |
| GitHub Pages 指向 `docs/` | ✅ 已发布 |
| **装依赖 / 构建 / 起服务（云端 runner 实测）** | ✅ **CI 通过，4132 有 HTTP 响应** |
| 本机安装依赖 | ❌ 未做（磁盘不足 + USB 为 FAT32） |
| 公网托管运行 | ❌ 未做（该工具读写本地 `~/.openbot`，公网托管会改变其存储与鉴权模型） |

## 上游同步

```bash
git remote add upstream https://github.com/meetopenbot/openbot.git
git fetch upstream --depth 1
git merge upstream/main
```
