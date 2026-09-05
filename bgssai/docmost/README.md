# 接到 bgssai-docmost

本目录是 `bgssai-build` 与 `bgssai-docmost` 之间的接线：装上之后，AI 写代码的同时会把
需求说明、概要设计、详细设计，以及类图、流程图、时序图、泳道图、状态图直接写进 docmost
的知识空间，带版本历史。

这是整套研发解决方案的落点。**AI 写完代码，用户手上只有一堆 diff**——为什么这样设计、
模块怎么交互、状态怎么流转，全在一次性的对话里，关掉就没了。文档写进 docmost 之后，
用户翻得到每一版，也看得出这一版跟上一版差在哪。

## 三步装好

### 1. 在 docmost 里签一枚访问令牌

登录 docmost 用户端，签发个人访问令牌（`bgs_doc_` 开头）。
**明文只显示这一次**，库里只存哈希，丢了重新签一枚，没有找回。

### 2. 跑安装脚本

```powershell
# Windows
pwsh -File bgssai/docmost/install.ps1
```

```sh
# macOS / Linux
sh bgssai/docmost/install.sh
```

脚本做两件事：把 `bgssai-design-docs` 这个 skill 装进 `~/.grok/skills/`，
把 MCP 配置并进 `~/.grok/config.toml`。可以重复跑：skill 覆盖更新，配置已经有了就跳过。

### 3. 设两个环境变量

| 变量 | 值 |
| --- | --- |
| `BGSSAI_DOCMOST_URL` | docmost 用户端地址，例如 `https://doc.bgssai.com`。不设时回落到 `http://127.0.0.1:8080` |
| `BGSSAI_DOCMOST_TOKEN` | 上一步签发的令牌 |

**令牌走环境变量而不是写进配置文件**：`config.toml` 是要进 Git、要发给同事的，
明文令牌一旦提交，撤回的代价远大于多设一个环境变量。

设好后重开终端，`grok mcp list` 里应该能看到 `bgssai-docmost`。

## 装完之后是什么样

在任何项目里让 AI 做功能开发，它会先 `list_spaces` 找到这个项目对应的知识空间，
然后按下面的结构把文档写进去：

```
<知识空间> = 项目
  └─ <功能名>
       ├─ 需求说明
       ├─ 概要设计      含流程图、泳道图
       └─ 详细设计      含时序图、类图、状态图
```

图一律是 Markdown 里的 Mermaid 代码块，不渲染成图片：**图是文本才能检索、才能 diff**，
变成 PNG 之后用户就只能看，比不出两版差在哪。

改文档走乐观锁——先 `get_page` 拿版本号再 `update_page`。用户可能正在网页上改同一篇，
版本对不上时 AI 要重新读、合并，而不是把用户的修改盖掉。

**没有删除工具**，这是故意的：AI 误删一棵页面子树的代价远大于便利，删除留给用户在网页上做。

## 连不上怎么办

skill 里写了降级路径：MCP 调不通时，文档写进项目仓库的 `docs/` 目录，并明确告诉用户
docmost 没连上、原因是什么。**不会因为写不进 docmost 就不写**——静默跳过是最坏的做法，
用户以为文档写好了，等要看的时候才发现什么都没有。

常见原因：

| 现象 | 原因 |
| --- | --- |
| 报「令牌无效」 | `BGSSAI_DOCMOST_TOKEN` 没设。变量没设时不报错，会原样把 `${BGSSAI_DOCMOST_TOKEN}` 发出去 |
| 连接被拒 | `BGSSAI_DOCMOST_URL` 没设，打到了本机 8080 |
| `grok mcp list` 里没有 | 装完没重开终端，或者 `~/.grok/config.toml` 里另有一份同名配置 |

## 文件说明

| 文件 | 作用 |
| --- | --- |
| `config.toml` | MCP 配置模板，装进 `~/.grok/config.toml` |
| `skills/bgssai-design-docs/SKILL.md` | 告诉 AI 写什么文档、写到哪、怎么写 |
| `install.ps1` / `install.sh` | 安装脚本，可重复运行 |

**光把 MCP 接上不够**：工具摆在那里，AI 不会自己想起来要写设计文档。
`SKILL.md` 才是让它真的动手的那一半，两个都得装。

接口契约在 `bgssai-docmost` 仓的 `docs/api/agent-doc-mcp.md`。
