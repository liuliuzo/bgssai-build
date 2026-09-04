# 产品愿景（PRODUCT_VISION）— BGSSAI Build

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

> 本文件是本仓库的**最高级别产品契约**。功能取舍、对外介绍、官网文案与本文件冲突时，一律以本文为准。
>
> **产品所有者 2026-09-01 正式确认的核心定位（原话还原）**：
>
> 1. **bgssai-build 是基于 grok-build 的 AI 编程工具**
> 2. **bgssai-bot 对标的是 grok-bot，由于 grok-bot 不开源所以使用 grok-build 作为驱动的产品**
>
> 凡是与上述定位冲突的设计，无论来自哪个层级，一律以本文为准。

---

## 一、产品定位

一句话定位：**BGSSAI Build（`bgssai-build`）是基于开源 [Grok Build](https://github.com/xai-org/grok-build) 的 AI 编程工具。**

| 项 | 说明 |
| --- | --- |
| 上游 | xAI 开源的 Grok Build：终端 AI 编码 Agent（全屏 TUI / Headless / ACP） |
| 本仓库 | 在 Grok Build 源码基础上建设的 BGSSAI 产品线 AI 编程工具 |
| 给谁用 | 研发、自动化脚本、支持 ACP 的编辑器 |
| 分发 | Windows 安装包在官网（bgssai-website）下载：https://www.bgssai.com/downloads/BGSSAI-Build-Setup.exe（不进 Git） |
| 解决什么 | 在真实代码库里理解上下文、改文件、跑命令、接 MCP、管理长任务 |

本仓库**不是** Grok Bot 的产品形态。桌面 Bot 产品见配套仓库 `bgssai-bot`。

---

## 二、与 bgssai-bot 的关系

两条产品必须成对理解，不能互相替代、也不能写成「同一运行时的两份副本」。

| 仓库 | 对标 | 定位 |
| --- | --- | --- |
| `bgssai-build` | Grok Build | 基于 Grok Build 的 **AI 编程工具** |
| `bgssai-bot` | Grok Bot | 对标 Grok Bot 的产品。Grok Bot 不开源，因此以 **Grok Build（本仓库）作为驱动** |

`bgssai-bot` 选用 Grok Build 做驱动，是因为对标对象 Grok Bot 未开源；本仓库提供那一层可开源、可构建、可嵌入的 Agent 能力。

---

## 三、目标用户与关键场景

- **研发**：在全屏终端中阅读代码库、编辑文件、执行命令、审阅 diff、管理长任务。
- **自动化 / CI**：headless 一次运行或脚本接入。
- **编辑器**：经 Agent Client Protocol（ACP）嵌入支持该协议的 IDE。

---

## 四、范围边界（做什么 / 不做什么）

**做：**

- 基于 Grok Build 的 AI 编程 Agent：TUI、headless、ACP、MCP 客户端、工作区工具、权限与沙箱。
- 作为 `bgssai-bot` 的驱动侧能力来源（Grok Build）。

**不做：**

- 不是 Grok Bot，也不做桌面 Bot 壳（那是 `bgssai-bot`）。
- 不是面向客户的业务 SaaS，不替代各业务产品的账号、权限与计费。
- 不把支付、发信等各产品明确禁止的高风险写操作做成默认能力。

---

## 五、技术基线

- 语言与运行时：Rust；CLI/TUI 入口与上游 Grok Build 一致。
- **分支**：`main` 只同步上游 Grok Build，与 grok-build 保持一致。BGSSAI 的默认分支是 **`develop`**；全部 BGSSAI 修改先在 feature 分支完成，再合入 `develop`。不要把 BGSSAI 提交写回 `main`。
- 同步关系：`main` 周期性同步上游 Grok Build；根目录 `SOURCE_REV` 记录对应 monorepo commit。同步后把 `main` 合入 `develop`。
- 配套产品：`bgssai-bot` 以本仓库 `develop` 所代表的 Grok Build 为 Agent 驱动（`bgssai-bot` 默认分支仍是 `develop`）。
