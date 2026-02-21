Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Get-CCBPContractIndex {
  param([Parameter(Mandatory=$true)][string]$RepoRoot)

  $p = Join-Path $RepoRoot "CONTRACT_INDEX.json"
  if (-not (Test-Path $p)) { throw "CCBP: missing CONTRACT_INDEX.json at repo root." }

  $raw = Get-Content -Path $p -Raw -Encoding UTF8
  $obj = $raw | ConvertFrom-Json

  if (-not $obj.schema) { throw "CCBP: CONTRACT_INDEX.json missing 'schema'." }
  if (-not $obj.repo.platform) { throw "CCBP: CONTRACT_INDEX.json missing 'repo.platform'." }
  if (-not $obj.inputs) { throw "CCBP: CONTRACT_INDEX.json missing 'inputs'." }

  return $obj
}

Export-ModuleMember -Function Get-CCBPContractIndex
