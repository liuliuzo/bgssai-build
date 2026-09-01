# 产品愿景（PRODUCT_VISION）— BGSSAI Build

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
| 分发 | Windows 安装包在官网下载：https://www.bgssai.com/downloads/BGSSAI-Build-Setup.exe（不进 Git） |
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
- 同步关系：本树周期性同步上游 Grok Build；根目录 `SOURCE_REV` 记录对应 monorepo commit。
- 配套产品：`bgssai-bot` 以本仓库所代表的 Grok Build 为 Agent 驱动。
