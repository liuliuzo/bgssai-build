## 产品线规划（全线统一）

BGSSAI 产品线按下面六条划分职责，各仓实现与文档不得与此冲突。

1. **BGSSAI** 是给一人公司（OPC）创业者的全行业工具集合，让用户能找到创业所需的全部工具。
2. **bgssai-website** 是公司官网，只对外介绍产品与服务，不承载产品操作、在线对话或中心账号。
3. **bgssai-chat** 提供对标 ChatGPT / Gemini / Claude home / Grok 的 Web 在线对话 AI。
4. **中心用户账号在 bgssai-chat**：可授权登录旗下各 App；各 App 同时可以有自己的用户账号体系，两者并存。
5. **bgssai-bot** 对标 Grok Bot。BGSSAI 的全部产品应用可以托管给 Bot 直接操作。
6. **bgssai-tokenhub** 是模型能力中枢，对接主流模型原生 API 并统一提供给旗下产品；分为境外 `bgssai-tokenhub-global` 与境内 `bgssai-tokenhub-cn`。

Tokenhub / Tokenhub-CN 是产品线模型中枢：对接主流模型原生 API，再提供给旗下产品使用。tokenhub-global 对接国际主流模型，tokenhub-cn 对接中国大陆模型。它们不是业务 App，也不是 oauth_client。

愿景唯一权威：`bgssai-skeleton/docs/PRODUCT-LINE-VISION.md`。本段是各仓副本，变更以该文件为准。

**本仓位置**：本仓是 AI 编程工具，参考 grok-build 与 cursor 的设计；同时是 bgssai-bot 的
Agent 内核来源。不是第 1 条里面向 OPC 用户的业务工具。

**与 `bgssai-docmost` 合起来是一套研发解决方案**：AI 写代码时，用户根本不知道它做了什么——
为什么这样设计、模块怎么交互、状态怎么流转，全在一次性的对话里，关掉就没了。所以本仓在编程的
同时，把软件工程该有的那套文档直接写进 `bgssai-docmost`：需求说明、概要设计、详细设计、
类图、流程图、时序图、泳道图、状态图。文档与代码同一次产出、同一处留存、带版本历史。
本仓的安装包也从 `bgssai-docmost` 的站点下载。

<div align="center">

<h1>
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://media.x.ai/v1/website/spacexai-symbol-white-transparent-0c31957f.png">
    <source media="(prefers-color-scheme: light)" srcset="https://media.x.ai/v1/website/spacexai-symbol-black-transparent-6435cf42.png">
    <img alt="SpaceXAI logo" src="https://media.x.ai/v1/website/spacexai-symbol-black-transparent-6435cf42.png" width="96">
  </picture>
  <br>
  Grok Build (<code>grok</code>)
</h1>

**Grok Build** is SpaceXAI's terminal-based AI coding agent. It runs as a
full-screen TUI that understands your codebase, edits files, executes shell
commands, searches the web, and manages long-running tasks — interactively,
headlessly for scripting/CI, or embedded in editors via the Agent Client
Protocol (ACP).

[Installing the released binary](#installing-the-released-binary) ·
[Building from source](#building-from-source) ·
[Documentation](#documentation) ·
[Repository layout](#repository-layout) ·
[Development](#development) ·
[Contributing](#contributing) ·
[License](#license)

![Grok Build TUI](https://media.x.ai/v1/website/universe-tui-screenshot-6f7a0837.png)

**Learn more about Grok Build at [x.ai/cli](https://x.ai/cli)**

This repository contains the Rust source for the `grok` CLI/TUI and its agent
runtime. It is synced periodically from the SpaceXAI monorepo.

A small `SOURCE_REV` file at the root records the full monorepo commit SHA
for the version of the code present in this tree.

</div>

---

## 产品定位（BGSSAI Build）

**bgssai-build 是基于 [Grok Build](https://github.com/xai-org/grok-build) 的 AI 编程工具。**

完整产品契约见 [`PRODUCT_VISION.md`](PRODUCT_VISION.md)。Git Flow：feature → `develop`（dev）→ `release`（test）→ `master`（prod）。`main` 只同步 grok-build。

Windows 安装包从 `bgssai-docmost` 站点下载（不进本仓库，不上官网）。

配套产品 `bgssai-bot` 对标 Grok Bot；因 Grok Bot 不开源，使用 Grok Build（本仓库）作为驱动。

下文保留上游 Grok Build 的安装、构建与开发说明。

---

## Installing the released binary

Prebuilt binaries are published for macOS, Linux, and Windows:

```sh
curl -fsSL https://x.ai/cli/install.sh | bash   # macOS / Linux / Git Bash
irm https://x.ai/cli/install.ps1 | iex          # Windows PowerShell
grok --version
```

See the [changelog](https://x.ai/build/changelog) for the latest fixes,
features, and improvements in each release.

## Building from source

Requirements:

- **Rust** — the toolchain is pinned by [`rust-toolchain.toml`](rust-toolchain.toml);
  `rustup` installs it automatically on first build.
- **[DotSlash](https://dotslash-cli.com)** — required so hermetic tools under
  [`bin/`](bin/) (notably [`bin/protoc`](bin/protoc)) can download and run.
  Install it and ensure `dotslash` is on your `PATH` **before** building:

  ```sh
  cargo install dotslash
  # or: prebuilt packages — https://dotslash-cli.com/docs/installation/
  /usr/bin/env dotslash --help   # sanity check
  ```

- **protoc** — proto codegen resolves [`bin/protoc`](bin/protoc) via DotSlash,
  or falls back to a `protoc` on `PATH` / `$PROTOC`.
- macOS and Linux are supported build hosts; Windows builds are best-effort
  and not currently tested from this tree.

```sh
cargo run -p xai-grok-pager-bin              # build + launch the TUI
cargo build -p xai-grok-pager-bin --release  # release binary: target/release/xai-grok-pager
cargo check -p xai-grok-pager-bin            # fast validation
```

The binary artifact is named `xai-grok-pager`; official installs ship it as
`grok`. On first launch it opens your browser to authenticate — see the
[authentication guide](crates/codegen/xai-grok-pager/docs/user-guide/02-authentication.md).

## Documentation

Full online documentation is available at
[docs.x.ai/build/overview](https://docs.x.ai/build/overview).

The user guide ships with the pager crate:
[`crates/codegen/xai-grok-pager/docs/user-guide/`](crates/codegen/xai-grok-pager/docs/user-guide/)
— getting started, keyboard shortcuts, slash commands, configuration, theming,
MCP servers, skills, plugins, hooks, headless mode, sandboxing, and more.

## Repository layout

| Path | Contents |
|------|----------|
| `crates/codegen/xai-grok-pager-bin` | Composition-root package; builds the `xai-grok-pager` binary |
| `crates/codegen/xai-grok-pager` | The TUI: scrollback, prompt, modals, rendering |
| `crates/codegen/xai-grok-shell` | Agent runtime + leader/stdio/headless entry points |
| `crates/codegen/xai-grok-tools` | Tool implementations (terminal, file edit, search, ...) |
| `crates/codegen/xai-grok-workspace` | Host filesystem, VCS, execution, checkpoints |
| `crates/codegen/...` | The rest of the CLI crate closure (config, MCP, markdown, sandbox, ...) |
| `crates/common/`, `crates/build/`, `prod/mc/` | Small shared leaf crates pulled in by the closure |
| `third_party/` | Vendored upstream source (Mermaid diagram stack) — see below |

> [!IMPORTANT]
> The root `Cargo.toml` (workspace members, dependency versions, lints,
> profiles) is **generated** — treat it as read-only. Prefer editing per-crate
> `Cargo.toml` files.

## Development

```sh
cargo check -p <crate>        # always target specific crates; full-workspace builds are slow
cargo test -p xai-grok-config # per-crate tests
cargo clippy -p <crate>       # lint config: clippy.toml at the repo root
cargo fmt --all               # rustfmt.toml at the repo root
```

## Contributing

> [!NOTE]
> External contributions are not accepted. See [`CONTRIBUTING.md`](CONTRIBUTING.md).

## License

First-party code in this repository is licensed under the **Apache License,
Version 2.0** — see [`LICENSE`](LICENSE).

Third-party and vendored code remains under its original licenses. See:

- [`THIRD-PARTY-NOTICES`](THIRD-PARTY-NOTICES) — crates.io / git dependencies,
  bundled UI themes, and **in-tree source ports** (including openai/codex and
  sst/opencode tool implementations)
- [`crates/codegen/xai-grok-tools/THIRD_PARTY_NOTICES.md`](crates/codegen/xai-grok-tools/THIRD_PARTY_NOTICES.md)
  — crate-local notice for the codex and opencode ports (license texts +
  Apache §4(b) change notice)
- [`third_party/NOTICE`](third_party/NOTICE) — vendored Mermaid-stack index
