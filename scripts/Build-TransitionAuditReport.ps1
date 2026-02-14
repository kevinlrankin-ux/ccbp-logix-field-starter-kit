param(
  [string]$TransitionCrPath = "changes/CR-0002_REALIZATION_REQUEST"
)

$RepoRoot = Get-Location
$EnvPath  = Join-Path $RepoRoot (Join-Path $TransitionCrPath "envelope.yaml")

if (!(Test-Path $EnvPath)) {
  Write-Host "BLOCKED: Missing transition envelope.yaml" -ForegroundColor Red
  exit 1
}

$Env = Get-Content $EnvPath -Raw

if ($Env -notmatch 'external_impact:\s*"?YES"?') {
  Write-Host "BLOCKED: external_impact must be YES" -ForegroundColor Red
  exit 1
}

$Match = [regex]::Match($Env,'required_previous_sim_hash:\s*"?(.+?)"?')
if (!$Match.Success) {
  Write-Host "BLOCKED: required_previous_sim_hash missing" -ForegroundColor Red
  exit 1
}

$SimHash = $Match.Groups[1].Value

$LabelHits = Get-ChildItem -Recurse -Filter "label_oh-01.json" | Where-Object {
  (Get-Content $_.FullName -Raw) -match $SimHash
}

$HashFound = $LabelHits.Count -gt 0

$OutPath = Join-Path $RepoRoot (Join-Path $TransitionCrPath "transition_audit_report.md")

$Lines = @()
$Lines += "# Transition Audit Report"
$Lines += ""
$Lines += "Required SIM Hash: $SimHash"
$Lines += "Hash Found in Repo: $HashFound"
$Lines += ""
$Lines += "Generated (UTC): $((Get-Date).ToUniversalTime().ToString("o"))"
$Lines += ""

($Lines -join "`n") | Set-Content -Path $OutPath -Encoding UTF8

Write-Host "WROTE: $OutPath" -ForegroundColor Green
exit 0
