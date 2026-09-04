# AGENTS.md

## 产品线规划（全线统一）

BGSSAI 产品线按下面五条划分职责，各仓实现与文档不得与此冲突。

1. **BGSSAI** 是给一人公司（OPC）创业者的全行业工具集合，让用户能找到创业所需的全部工具。
2. **bgssai-website** 是公司官网，只对外介绍产品与服务，不承载产品操作、在线对话或中心账号。
3. **bgssai-chat** 提供对标 ChatGPT / Gemini / Claude home / Grok 的 Web 在线对话 AI。
4. **中心用户账号在 bgssai-chat**：可授权登录旗下各 App；各 App 同时可以有自己的用户账号体系，两者并存。
5. **bgssai-bot** 对标 Grok Bot。BGSSAI 的全部产品应用可以托管给 Bot 直接操作。

Tokenhub / Tokenhub-CN 是模型网关，不是业务 App，也不是 oauth_client。

愿景唯一权威：`bgssai-skeleton/docs/PRODUCT-LINE-VISION.md`。本段是各仓副本，变更以该文件为准。

**本仓位置**：本仓是 AI 编程工具（对标 Grok Build），同时是 bgssai-bot 的 Agent 内核来源，不是第 1 条里面向 OPC 用户的业务工具。

> 本文件与 `CLAUDE.md` 内容保持一致（供不同 AI 工具各自读取），改一处必须同步改另一处。

## 仓库定位

本仓库是 grok-build 的 fork，作为 BGSSAI 的 AI 编程工具，并向 `bgssai-bot` 提供 Agent 内核源码。
详细产品契约见 `PRODUCT_VISION.md`。

- **`main`**：只同步上游 [Grok Build](https://github.com/xai-org/grok-build)，与 grok-build 保持一致。不要把 BGSSAI 改动提交到 `main`。
- **`develop`**：本仓默认分支。全部 BGSSAI 修改合入这里。
- **AI Agent**：先在独立 feature 分支上改，验证后再合并到 `develop`。

本仓不是 Grok Bot，也不做桌面 Bot 壳——那是 `bgssai-bot`。

## 强制约定

* 提交信息遵循 Conventional Commits。
* **AI 成本红线**：不得创建 PR 后会持续唤醒 AI 的 heartbeat / automation / 后台轮询；PR 状态仅在当前会话单次查询或用户下次交互时再查。
* 一切产出物（代码 / 文档 / 提交信息 / PR 描述 / 评审与回信）**全局禁用 emoji 及装饰性图形符号**；语义性符号（→、×、§ 等）不属装饰性符号，允许使用。

## Git 分支（Git Flow，强制）

本产品线严格遵循 Git Flow。GitHub 默认分支一律是 **`develop`**。

| 分支 | 用途 | 发布环境 |
| --- | --- | --- |
| `feature/*` | Agent / 开发者的工作分支 | 不直接发布 |
| `develop` | 集成分支（默认分支） | 开发环境 |
| `release` | 测试冻结 | 测试环境 |
| `master` | 生产冻结 | 生产环境 |

- **AI Agent 必须先创建自己的 feature 分支再改文件**；禁止直接在 `develop` / `release` / `master` / `main` 上改。
- **`main` 例外（仅本仓）**：只同步上游 grok-build，与 grok-build 保持一致。禁止把 BGSSAI 改动提交到 `main`。同步后把 `main` 合入 `develop`。生产发布走 **`master`**，不要把 `main` 当成生产分支。
- Feature 合入 **`develop`**（先开 PR）。`develop` → `release`、`release` → `master` 的晋升同样先开 PR。
- 开发环境发布 **`develop`**；测试环境发布 **`release`**；生产环境发布 **`master`**。
- 用户明确同意合并或直接要求合并时，可以执行指定 PR 的合并，无需再次询问。
- 用户未明确同意且未提出合并要求时，不得合并、开启 auto-merge，或直接推送到 `develop`、`release`、`master`、`main`、`Master` 等受保护分支。
- 合并前必须确认仓库、源分支、目标分支和待合并 commit；授权仅限用户指定的 PR 或分支，不得扩展到其他 PR 或分支。
- 本地 commit、远端工作分支 push、GitHub PR 创建和分支合并是四个不同状态，不得混淆或省略。
- 创建或更新 PR 后，对用户只说整体结果（已开 PR 等确认，或已合入 develop），不要列出 SHA、文件清单或检查详情。
- PR 状态查询遵守 **AI 成本红线**：不创建 PR 后持续唤醒的后台监控；在用户下一次交互开始时查询 PR 最新状态即可。

## 向用户汇报（强制）

用户不看、也看不懂修改细节。对用户**只汇报整体进度与结果**（做到哪一步、是否完成、要不要拍板）。禁止输出文件清单、diff、命令日志、commit SHA、逐仓 PR 表、工具过程。需要时最多给一个链接。

