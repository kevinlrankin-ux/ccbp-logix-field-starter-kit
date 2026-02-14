param(
  [string]$CrPath = "changes/CR-0001",
  [string]$Approver = "Kevin Rankin"
)

$RepoRoot  = Get-Location
$LabelPath = Join-Path $RepoRoot (Join-Path $CrPath "label_oh-01.json")
$StampPath = Join-Path $RepoRoot (Join-Path $CrPath "stamp.yaml")

if (!(Test-Path $LabelPath)) {
  Write-Host "STAMP BLOCKED: Missing label_oh-01.json (run scripts/OH-01_Label.ps1 first)" -ForegroundColor Red
  exit 1
}

$Label = Get-Content $LabelPath -Raw | ConvertFrom-Json
$Hash  = $Label.structure_hash_sha256

$Confirm = Read-Host "Type STAMP to authorize and seal envelope at hash $Hash"
if ($Confirm -ne "STAMP") {
  Write-Host "Stamp cancelled." -ForegroundColor Yellow
  exit 1
}

$Yaml = @()
$Yaml += "stamp:"
$Yaml += "  approver: ""$Approver"""
$Yaml += "  cr_path: ""$CrPath"""
$Yaml += "  oh_step: ""OH-01"""
$Yaml += "  sealed_structure_hash_sha256: ""$Hash"""
$Yaml += "  stamped_utc: ""2026-02-14T19:03:53.9041329Z"""
$YamlString = ($Yaml -join "
") + "
"

Set-Content -Path $StampPath -Value $YamlString -Encoding UTF8
Write-Host "STAMPED: $StampPath" -ForegroundColor Green
# ------------------------------------------------
# AUTO_LEDGER_WRITE: append stamp + hash to ledger/hash_registry.jsonl
# ------------------------------------------------
try {
  \C:\Users\kevlr\OneDrive\Downloads\ccbp-rockwell-conveyor-line\ledger = Join-Path \C:\Users\kevlr\OneDrive\Downloads\ccbp-rockwell-conveyor-line "ledger"
  if (!(Test-Path \C:\Users\kevlr\OneDrive\Downloads\ccbp-rockwell-conveyor-line\ledger)) { New-Item -ItemType Directory -Path \C:\Users\kevlr\OneDrive\Downloads\ccbp-rockwell-conveyor-line\ledger | Out-Null }
  \ = Join-Path \C:\Users\kevlr\OneDrive\Downloads\ccbp-rockwell-conveyor-line\ledger "hash_registry.jsonl"
  if (!(Test-Path \)) { New-Item -ItemType File -Path \ | Out-Null }

  # \ already computed from label_oh-01.json in this script
  \ = @{
    ts_utc = (Get-Date).ToUniversalTime().ToString("o")
    scope = "REAL"
    cr_path = \C:\Users\kevlr\OneDrive\Downloads\ccbp-rockwell-conveyor-line\changes\CR-0002_REALIZATION_REQUEST
    structure_hash_sha256 = \
    approver = \
  }

  (\ | ConvertTo-Json -Compress) | Add-Content -Path \ -Encoding UTF8
  Write-Host "LEDGER APPENDED: \" -ForegroundColor Cyan
} catch {
  Write-Host "LEDGER WARN: failed to append ledger entry (\)" -ForegroundColor Yellow
}
# AUTO_LEDGER_WRITE
exit 0
