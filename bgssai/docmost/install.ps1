# 把 bgssai-build 接到 bgssai-docmost：装 skill、并入 MCP 配置。
#
# 用法（Windows）：
#   pwsh -File bgssai/docmost/install.ps1
#
# 脚本可以重复跑：skill 目录覆盖更新，MCP 配置已经有了就不再追加。
# 带 BOM 存盘是为了 Windows PowerShell 5.1 也能正确读出中文。

$ErrorActionPreference = 'Stop'

$grokHome = if ($env:GROK_HOME) { $env:GROK_HOME } else { Join-Path $HOME '.grok' }
$here = Split-Path -Parent $MyInvocation.MyCommand.Path

New-Item -ItemType Directory -Force -Path (Join-Path $grokHome 'skills') | Out-Null

# 1. skill：整目录覆盖。skill 是本仓维护的产物，本地改了也应该被新版盖掉。
$skillSrc = Join-Path $here 'skills\bgssai-design-docs'
$skillDst = Join-Path $grokHome 'skills\bgssai-design-docs'
# 先删再拷：Copy-Item -Recurse 往一个已存在的目录拷，是拷「进去」而不是覆盖，
# 重复安装会在 skill 目录下面再套一层同名目录。
Remove-Item -Recurse -Force $skillDst -ErrorAction SilentlyContinue
Copy-Item -Recurse -Force $skillSrc $skillDst
Write-Host "已安装 skill: $skillDst"

# 2. MCP 配置：追加而不是覆盖。用户的 config.toml 里还有别的东西，
#    整个文件覆盖会把人家的模型设置、其它 MCP server 一起抹掉。
$configPath = Join-Path $grokHome 'config.toml'
$block = Get-Content -Raw -Path (Join-Path $here 'config.toml')

if (-not (Test-Path $configPath)) {
    Set-Content -Path $configPath -Value $block -Encoding utf8
    Write-Host "已创建配置: $configPath"
}
elseif ((Get-Content -Raw -Path $configPath) -match '\[mcp_servers\.bgssai-docmost\]') {
    Write-Host "配置里已有 bgssai-docmost，跳过（要改地址请直接编辑 $configPath）"
}
else {
    Add-Content -Path $configPath -Value "`n$block" -Encoding utf8
    Write-Host "已并入配置: $configPath"
}

# 3. 环境变量只提示不代设：这两个值因人而异，脚本替用户猜一个写进去，
#    等到连不上的时候他还得先发现是脚本猜的。
Write-Host ''
Write-Host '还差两个环境变量，设好就能用了：'
Write-Host '  BGSSAI_DOCMOST_URL    docmost 地址，例如 https://doc.bgssai.com'
Write-Host '  BGSSAI_DOCMOST_TOKEN  在 docmost 网页里签发的访问令牌（bgs_doc_ 开头）'
Write-Host ''
Write-Host '当前值：'
Write-Host ("  BGSSAI_DOCMOST_URL   = " + $(if ($env:BGSSAI_DOCMOST_URL) { $env:BGSSAI_DOCMOST_URL } else { '(未设置，将回落到 http://127.0.0.1:8080)' }))
Write-Host ("  BGSSAI_DOCMOST_TOKEN = " + $(if ($env:BGSSAI_DOCMOST_TOKEN) { '(已设置)' } else { '(未设置)' }))
Write-Host ''
Write-Host '永久设置（当前用户）：'
Write-Host '  [Environment]::SetEnvironmentVariable("BGSSAI_DOCMOST_URL", "https://doc.bgssai.com", "User")'
Write-Host '  [Environment]::SetEnvironmentVariable("BGSSAI_DOCMOST_TOKEN", "bgs_doc_...", "User")'
Write-Host ''
Write-Host '设好后重开终端，跑 grok mcp list 应该能看到 bgssai-docmost。'
