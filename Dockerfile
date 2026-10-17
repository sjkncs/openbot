# syntax=docker/dockerfile:1
# OpenBot 复刻镜像 —— 多阶段构建，运行阶段只带生产依赖
#
# 说明：上游 pnpm-lock.yaml 与 package.json 不一致（lockfile 多出 3 个 specifier），
# 因此这里用 --no-frozen-lockfile（与 CI 保持一致）。详见 REPLICA_NOTES.md。

# ---------- 构建阶段 ----------
FROM node:22-alpine AS build
WORKDIR /app
RUN corepack enable

COPY package.json pnpm-lock.yaml ./
RUN pnpm install --no-frozen-lockfile

COPY tsconfig.json ./
COPY src ./src
RUN pnpm build

# ---------- 运行阶段 ----------
FROM node:22-alpine AS runtime
WORKDIR /app
ENV NODE_ENV=production
ENV PORT=4132
RUN corepack enable

COPY package.json pnpm-lock.yaml ./
RUN pnpm install --no-frozen-lockfile --prod && pnpm store prune

COPY --from=build /app/dist ./dist

# 运行时数据落在 ~/.openbot；挂卷以便持久化
VOLUME ["/root/.openbot"]

EXPOSE 4132

HEALTHCHECK --interval=30s --timeout=5s --start-period=15s --retries=3 \
  CMD wget -qO- http://127.0.0.1:4132/api/health || exit 1

CMD ["node", "dist/app/cli.js", "start"]
