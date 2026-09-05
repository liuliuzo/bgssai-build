# BGSSAI Build UI 设计与优化规格说明书

## 1. 设计背景与定位

BGSSAI Build（`bgssai-build`）是基于开源 Grok Build 结合 Cursor 设计哲学的专业 AI 编程工具，与 `bgssai-docmost` 共同构成 BGSSAI 研发一体化透明协同解决方案。

传统 AI 编程助手存在严重的“黑盒”问题：用户只看到代码被改动，完全不了解 AI 是如何思考、架构划分、类与时序如何流转的。
`bgssai-build` 通过融合两大开源标杆的 UI/UX 设计，实现以下突破：

1. **融合 Grok Build 的终端硬核能力**：高速全屏 TUI、强大的 Agent 运行时、Slash 指令体系（`/doctor`、`/simplify`、`/plan`、`/doc`）、底层 ACP/MCP 协议接入与系统级沙箱。
2. **融合 Cursor 的极简现代交互**：
   - **双模态工作空间**：独立 Agents Window（聚焦式智能体工作台）与 Editor + Agent Split（经典 IDE 双栏编辑）；
   - **居中 Composer**：支持 `@` 跨文件上下文、`/` 技能指令调用、快捷模型切换；
   - **分步执行透明可视化**：工具调用流水线（Explored / Ran / Edited）清晰折叠；
   - **Files Changed 差异审查卡片**：细粒度 Diff、行级采纳与审查；
   - **系统化生态配置**：Skills、Rules、MCP、Subagents 统一面板。
3. **BGSSAI 专属核心机制——Docmost 实时软工设计沉淀 (Docmost Realtime Engineering Sync)**：
   - AI 在生成代码的同时，自动通过 MCP 协议向 `bgssai-docmost` 写入标准软件工程文档（需求规格 PRD、概要设计 HLD、详细设计 LLD）及 UML 架构图（类图、时序图、流程图、泳道图、状态图、ER图）；
   - UI 界面中实时呈现 Docmost 同步状态卡片与 UML 矢量图预览，并支持一键跨端跳转至 Docmost 知识库审查历史快照与版本比对。

---

## 2. 界面架构与模态设计

BGSSAI Build 规划并提供三大界面模态，满足不同研发场景诉求：

### 2.1 独立 Agents 窗口（Agents Window）
- **适用场景**：需求头脑风暴、大型项目重构、长任务异步执行、跨仓库协作。
- **界面结构**：
  - **顶部标题栏（Titlebar）**：窗口操作、仓库/工作区导航、IDE 快速切换按钮；
  - **左侧边栏（Sidebar）**：
    - 快速启动（New Chat）；
    - 全局检索（Search）、自动化任务（Automations）、自定义中心（Customize）；
    - 仓库与工作树列表（Repositories / Worktrees）；
    - 用户身份信息与 Docmost 接入状态徽章；
  - **主内容区（Main Area）**：
    - **初始空态（Home）**：分支上下文 Chips、居中智能 Composer、快捷行动（Plan New Idea、Multitask、Sync Docmost）；
    - **执行态（Chat & Execution）**：
      - Agent 思考与工具调用卡片；
      - **Docmost 软工文档输出卡片（PRD/HLD/LLD 及 Mermaid 架构图）**；
      - Files Changed 代码变更审查卡片；
      - 底部 Follow-up 输入区与快捷模型选择器。

### 2.2 经典编辑器工作区（Editor + Agent Mode）
- **适用场景**：日常精细化代码编写、单文件编辑、断点调试。
- **界面结构**：
  - **左侧活动栏与资源管理器**：文件目录树、Git 变更指示、符号大纲；
  - **中央编辑区**：Monaco 式代码编辑窗口，支持行内 Inline Diff、Ctrl+K 行内编辑；
  - **右侧嵌入式 Agent 面板**：同 Agents Window 的交互流，实时展示代码改动与对应生成的软件工程设计文档。

### 2.3 终端全屏 TUI 模式（Grok Build Terminal Mode）
- **适用场景**：纯命令行环境、SSH 远程服务器、极客开发者。
- **界面结构**：
  - 基于 Ratatui 的流式文本滚动区；
  - 底部多功能状态栏（Status Bar）展示 Git 分支、Token 消耗遥测、Docmost 同步健康度；
  - 交互式快捷命令底栏（Dock / Shortcuts Bar）。

---

## 3. 页面与组件规范

| 页面标识 | 页面名称 | 关键参考要素 | 核心特色能力 |
| :--- | :--- | :--- | :--- |
| `agents-window.html` | Agents 独立主页 | Cursor Agents Window | 居中 Composer、Tokenhub 驱动的模型选择器、Docmost 接入指示 |
| `agents-chat.html` | 协同对话与透明设计流 | Cursor Agents Chat + Grok Build Task | 工具执行流水线、Docmost 实时软工设计卡片、UML 矢量图内嵌预览、Files Changed 卡片 |
| `editor-agent.html` | 编辑器与 Agent 双栏 | Cursor Classic Editor | 目录树、代码编辑、行内 Diff、右侧协同 Agent 侧栏 |
| `agent-plan.html` | 研发计划模式 (Plan Mode) | Cursor Plan / Grok Build Goal | 结构化任务拆解、PRD 需求提炼、架构设计前置确认 |
| `agent-review.html` | 架构与代码审查模式 | Cursor Review | 代码 Diff 对比与 UML 类图/时序图联动审查、PR 与文档同步提交 |
| `docmost-sync.html` | Docmost 知识库协同中心 | BGSSAI 独创体系 | 空间页面树、PRD/HLD/LLD 自动归档、Mermaid 架构图预览、PAT 令牌管理 |
| `mcp.html` | MCP 工具管理中心 | Cursor MCP Settings | `bgssai-docmost` 工具链状态、Tokenhub 协议对接、工具授权与日志 |
| `skills.html` | Skills 技能中心 | Cursor Skills + Grok Build Skills | `bgssai-design-docs` 软工技能、`/simplify`、`/test`、`/review` 指令 |
| `rules.html` | 规则与指令规范 | Cursor Rules | `AGENTS.md`、`CLAUDE.md` 规则查看与动态热重载 |
| `settings-models.html` | 模型中枢与路由设置 | Cursor Models Settings | 对接 `bgssai-tokenhub` 境内/境外双中枢，模型选择与参数设置 |
| `tui-terminal.html` | Grok Build 终端 TUI 仿真 | Grok Build Pager | 高保真终端仿真、底栏状态监控、Ratatui 交互、Docmost 同步指标 |

---

## 4. 视觉与主题设计系统

1. **色彩系统**：
   - 默认浅色（Light）：对齐 Cursor 2026 最新官方 live 规范，纯净灰白底色（`#ffffff` / `#f5f5f5`），沉稳文字（`#1a1a1a` / `#5c5c5c`）；
   - 深色主题（Dark）：极客深灰配色（`#141414` / `#1c1c1c`），护眼微光高亮；
   - 品牌主色：BGSSAI 智汇蓝（`#2563eb` / `#3b82f6`），辅助绿色（`#10b981` 用于成功与代码增加），告警橙色（`#f59e0b`）。
2. **排版与字体**：
   - 界面字体：Inter, -apple-system, BlinkMacSystemFont, "Segoe UI", "PingFang SC", sans-serif；
   - 代码与命令：ui-monospace, "SF Mono", Menlo, Consolas, monospace；
3. **红线与设计约束**：
   - 严格遵循 `BGSSAI-Standards.md`：全局禁用 emoji 及装饰性图形符号，所有操作指示与按钮使用语义性符号（→、×、§ 等）或专业图标；
   - 所有前后端及 MCP 数据结构遵循标准 `snake_case` 规范。
