$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

try {
  . (Join-Path $PSScriptRoot "local-paths.ps1")
  Resolve-LocalPaths $PSScriptRoot
  $bootstrapPath = Join-Path $env:PLUGIN_ROOT "scripts\runtime-bootstrap.ps1"
  $entrypoint = Join-Path $env:PLUGIN_ROOT "runtime\management-helper.mjs"

  if (-not [Environment]::Is64BitOperatingSystem) {
    throw "Unsupported management helper target"
  }
  if (-not (Test-Path -LiteralPath $env:PLUGIN_DATA -PathType Container) -or
      -not (Test-Path -LiteralPath $bootstrapPath -PathType Leaf) -or
      -not (Test-Path -LiteralPath $entrypoint -PathType Leaf)) {
    throw "Packaged management runtime is unavailable"
  }

  . $bootstrapPath
  $nodePath = Get-VerifiedNodeRuntime
  & $nodePath $entrypoint @args
  exit $LASTEXITCODE
} catch {
  [Console]::Error.WriteLine("Plugin runtime is unavailable: verify native user data permissions and reinstall the package if assets are missing")
  exit 1
}
