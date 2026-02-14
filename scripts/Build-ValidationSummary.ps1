param(
  [string]$CrPath = "changes/CR-0001"
)

$RepoRoot = Get-Location
$LabelPath = Join-Path $RepoRoot (Join-Path $CrPath "label_oh-01.json")
$StampPath = Join-Path $RepoRoot (Join-Path $CrPath "stamp.yaml")
$Approved  = Join-Path $RepoRoot "plc\approved\CR-0001_Approved.txt"

if (!(Test-Path $LabelPath)) {
  Write-Host "BLOCKED: Missing label_oh-01.json" -ForegroundColor Red
  exit 1
}

$Label = Get-Content $LabelPath -Raw | ConvertFrom-Json
$Hash  = $Label.structure_hash_sha256

$StampPresent = Test-Path $StampPath
$ApprovedPresent = Test-Path $Approved

$OutPath = Join-Path $RepoRoot (Join-Path $CrPath "validation_summary.md")

$Lines = @()
$Lines += "# Validation Summary"
$Lines += ""
$Lines += "Structure Hash: $Hash"
$Lines += "Label Created (UTC): $($Label.created_utc)"
$Lines += ""
$Lines += "Stamp Present: $StampPresent"
$Lines += "Approved Artifact Present: $ApprovedPresent"
$Lines += ""
$Lines += "Generated (UTC): $((Get-Date).ToUniversalTime().ToString("o"))"
$Lines += ""

($Lines -join "`n") | Set-Content -Path $OutPath -Encoding UTF8

Write-Host "WROTE: $OutPath" -ForegroundColor Green
exit 0
