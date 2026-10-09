$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

try {
  . (Join-Path $PSScriptRoot "local-paths.ps1")
  Resolve-LocalPaths $PSScriptRoot
  $bootstrapPath = Join-Path $env:PLUGIN_ROOT "scripts\runtime-bootstrap.ps1"
  $serverPath = Join-Path $env:PLUGIN_ROOT "runtime\shared-analytics-mcp.mjs"

  if (-not [Environment]::Is64BitOperatingSystem) {
    throw "Unsupported runtime target: Windows requires x64"
  }
  if (-not (Test-Path -LiteralPath $env:PLUGIN_DATA -PathType Container) -or
      -not (Test-Path -LiteralPath $bootstrapPath -PathType Leaf) -or
      -not (Test-Path -LiteralPath $serverPath -PathType Leaf)) {
    throw "Packaged Rob Creator Analytics runtime is unavailable"
  }

  . $bootstrapPath
  $nodePath = Get-VerifiedNodeRuntime
  & $nodePath $serverPath
  exit $LASTEXITCODE
} catch {
  [Console]::Error.WriteLine("Plugin runtime is unavailable: verify native user data permissions and reinstall the package if assets are missing")
  exit 1
}
