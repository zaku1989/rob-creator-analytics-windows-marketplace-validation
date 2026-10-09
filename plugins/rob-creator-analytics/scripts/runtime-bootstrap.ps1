$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest
. (Join-Path $PSScriptRoot "local-paths.ps1")
$runtimeScriptDirectory = $PSScriptRoot

function Get-VerifiedNodeRuntime {
  Resolve-LocalPaths $runtimeScriptDirectory

  $layoutPath = Join-Path $env:PLUGIN_ROOT "runtime\win32-x64\layout.json"
  if (-not (Test-Path -LiteralPath $layoutPath -PathType Leaf) -or
      -not (Test-Path -LiteralPath $env:PLUGIN_DATA -PathType Container)) {
    throw "Verified packaged runtime is unavailable"
  }
  $layout = Get-Content -LiteralPath $layoutPath -Raw -Encoding UTF8 | ConvertFrom-Json
  $expectedSha = "ba4e6d110e8c1592a1ecd390f6b05f3da124b13871a5be62b341a07a853c6c32"
  if ($layout.target -ne "win32-x64" -or $layout.nodeVersion -ne "24.21.0" -or
      $layout.packagingMode -ne "chunked" -or $layout.finalFilename -ne "node.exe" -or
      [Int64]$layout.finalSize -ne 93580104 -or $layout.finalSha256 -ne $expectedSha -or
      [Int32]$layout.chunkCount -ne 2 -or $layout.chunks.Count -ne 2) {
    throw "Packaged runtime metadata is invalid"
  }

  $cacheParent = Join-Path $env:RCA_RUNTIME_CACHE_ROOT (
    "node-v{0}\{1}\{2}" -f $layout.nodeVersion, $layout.target, $layout.finalSha256
  )
  $finalPath = Join-Path $cacheParent $layout.finalFilename
  $lockPath = Join-Path $cacheParent "reconstruct.lock"
  [IO.Directory]::CreateDirectory($cacheParent) | Out-Null

  function Test-RuntimeFile([string]$Path) {
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { return $false }
    if ((Get-Item -LiteralPath $Path).Length -ne [Int64]$layout.finalSize) { return $false }
    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash.ToLowerInvariant() -eq $layout.finalSha256
  }

  if (Test-RuntimeFile $finalPath) { return $finalPath }

  $lock = $null
  $deadline = [DateTime]::UtcNow.AddSeconds(30)
  while ($null -eq $lock -and [DateTime]::UtcNow -lt $deadline) {
    try {
      $lock = [IO.File]::Open(
        $lockPath,
        [IO.FileMode]::OpenOrCreate,
        [IO.FileAccess]::ReadWrite,
        [IO.FileShare]::None
      )
    } catch [IO.IOException] {
      if (Test-RuntimeFile $finalPath) { return $finalPath }
      Start-Sleep -Milliseconds 100
    }
  }
  if ($null -eq $lock) { throw "Runtime reconstruction lock timed out" }

  $tempPath = Join-Path $cacheParent (".node.tmp.{0}.{1}" -f $PID, [Guid]::NewGuid().ToString("N"))
  try {
    if (Test-RuntimeFile $finalPath) { return $finalPath }
    Get-ChildItem -LiteralPath $cacheParent -Filter ".node.tmp.*" -File -ErrorAction SilentlyContinue |
      Remove-Item -Force -ErrorAction SilentlyContinue
    if (Test-Path -LiteralPath $finalPath) { Remove-Item -LiteralPath $finalPath -Force }

    $output = [IO.File]::Open(
      $tempPath,
      [IO.FileMode]::CreateNew,
      [IO.FileAccess]::Write,
      [IO.FileShare]::None
    )
    try {
      foreach ($chunk in $layout.chunks) {
        if ($chunk.path -notmatch '^node-parts/node\.exe\.part-[0-9]{3}$') {
          throw "Runtime chunk path is invalid"
        }
        $chunkPath = Join-Path (Join-Path $env:PLUGIN_ROOT "runtime\win32-x64") $chunk.path
        if (-not (Test-Path -LiteralPath $chunkPath -PathType Leaf) -or
            (Get-Item -LiteralPath $chunkPath).Length -ne [Int64]$chunk.bytes -or
            (Get-FileHash -LiteralPath $chunkPath -Algorithm SHA256).Hash.ToLowerInvariant() -ne $chunk.sha256) {
          throw "Runtime chunk verification failed"
        }
        $inputStream = [IO.File]::OpenRead($chunkPath)
        try { $inputStream.CopyTo($output) } finally { $inputStream.Dispose() }
      }
      $output.Flush($true)
    } finally {
      $output.Dispose()
    }

    if (-not (Test-RuntimeFile $tempPath)) { throw "Reconstructed runtime verification failed" }
    [IO.File]::Move($tempPath, $finalPath)
    if (-not (Test-RuntimeFile $finalPath)) { throw "Final runtime verification failed" }
    return $finalPath
  } finally {
    if (Test-Path -LiteralPath $tempPath) {
      Remove-Item -LiteralPath $tempPath -Force -ErrorAction SilentlyContinue
    }
    $lock.Dispose()
    Remove-Item -LiteralPath $lockPath -Force -ErrorAction SilentlyContinue
  }
}
