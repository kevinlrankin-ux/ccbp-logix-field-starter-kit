Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Invoke-CCBPPack {
  param(
    [Parameter(Mandatory=$true)][string]$RepoRoot,
    [Parameter(Mandatory=$true)][object]$Contract,
    [Parameter(Mandatory=$true)][object]$AspPosture
  )

  if ([bool]$Contract.gates.require_human_for_release_packaging) {
    throw "CCBP: pack is gated (require_human_for_release_packaging=true). Flip gate explicitly to proceed."
  }

  Ensure-Dir (Join-Path $RepoRoot "dist")
  $stamp = (Get-Date).ToUniversalTime().ToString("yyyyMMddTHHmmssZ")
  $zipPath = Join-Path $RepoRoot ("dist\field-pack-" + $stamp + ".zip")

  $items = @(
    (Join-Path $RepoRoot "artifacts"),
    (Join-Path $RepoRoot "governance"),
    (Join-Path $RepoRoot "CONTRACT_INDEX.json")
  ) | Where-Object { Test-Path $_ }

  Compress-Archive -Path $items -DestinationPath $zipPath -Force
  Write-CLPLine ("Wrote: " + $zipPath)
}

Export-ModuleMember -Function Invoke-CCBPPack
