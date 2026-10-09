function Resolve-LocalPaths([string]$ScriptDirectory) {
  $pluginRoot = [IO.Path]::GetFullPath((Join-Path $ScriptDirectory ".."))
  if ([string]::IsNullOrWhiteSpace($env:LOCALAPPDATA) -or
      $env:LOCALAPPDATA -notmatch '^[A-Za-z]:[\\/]') {
    throw "Native local data directory is unavailable"
  }
  $contract = Get-Content -LiteralPath (Join-Path $pluginRoot "scripts\local-paths.json") -Raw -Encoding UTF8 | ConvertFrom-Json
  if ($contract.schemaVersion -ne 1 -or $contract.windowsDataSuffix -ne "Rob Creator Analytics/Codex" -or
      $contract.stateDirectory -ne "state" -or $contract.runtimeCacheDirectory -ne "runtime-cache") {
    throw "Local paths contract is invalid"
  }
  $dataRoot = Join-Path $env:LOCALAPPDATA $contract.windowsDataSuffix
  $stateRoot = Join-Path $dataRoot $contract.stateDirectory
  $cacheRoot = Join-Path $dataRoot $contract.runtimeCacheDirectory
  [IO.Directory]::CreateDirectory($stateRoot) | Out-Null
  [IO.Directory]::CreateDirectory($cacheRoot) | Out-Null
  # Internal communication only: overwrite misleading legacy host variables.
  $env:PLUGIN_ROOT = $pluginRoot
  $env:PLUGIN_DATA = $dataRoot
  $env:RCA_STATE_ROOT = $stateRoot
  $env:RCA_RUNTIME_CACHE_ROOT = $cacheRoot
}
