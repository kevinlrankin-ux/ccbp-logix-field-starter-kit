param(
  [string]$CrPath = "changes/CR-0001",
  [string]$Approver = "Kevin Rankin"
)

$RepoRoot = Get-Location
$CrFull   = Join-Path $RepoRoot $CrPath
$LabelPath = Join-Path $CrFull "label_oh-01.json"
$StampPath = Join-Path $CrFull "stamp.yaml"

if (!(Test-Path $LabelPath)) {
  Write-Host "STAMP BLOCKED: Missing label_oh-01.json (run OH-01_Label.ps1 first)" -ForegroundColor Red
  exit 1
}

$Label = Get-Content $LabelPath -Raw | ConvertFrom-Json
$Hash  = $Label.structure_hash_sha256

$Confirm = Read-Host "Type STAMP to authorize and seal envelope at hash $Hash"
if ($Confirm -ne "STAMP") {
  Write-Host "Stamp cancelled." -ForegroundColor Yellow
  exit 1
}

# Write stamp.yaml
$Yaml = @()
$Yaml += "stamp:"
$Yaml += "  approver: ""$Approver"""
$Yaml += "  cr_path: ""$CrPath"""
$Yaml += "  sealed_structure_hash_sha256: ""$Hash"""
$Yaml += "  stamped_utc: ""$((Get-Date).ToUniversalTime().ToString("o"))"""
$YamlString = ($Yaml -join "`n") + "`n"

Set-Content -Path $StampPath -Value $YamlString -Encoding UTF8
Write-Host "STAMPED: $StampPath" -ForegroundColor Green

# ------------------------------------------------
# DETERMINISTIC LEDGER APPEND
# ------------------------------------------------
try {
  $LedgerDir = Join-Path $RepoRoot "ledger"
  if (!(Test-Path $LedgerDir)) { New-Item -ItemType Directory -Path $LedgerDir | Out-Null }

  $LedgerPath = Join-Path $LedgerDir "hash_registry.jsonl"
  if (!(Test-Path $LedgerPath)) { New-Item -ItemType File -Path $LedgerPath | Out-Null }

  $Record = @{
    ts_utc = (Get-Date).ToUniversalTime().ToString("o")
    scope  = "REAL"
    cr_path = $CrPath
    structure_hash_sha256 = $Hash
    approver = $Approver
    stamp_path = $StampPath
    label_path = $LabelPath
  }

  ($Record | ConvertTo-Json -Compress) | Add-Content -Path $LedgerPath -Encoding UTF8
  Write-Host "LEDGER APPENDED: $LedgerPath" -ForegroundColor Cyan
}
catch {
  Write-Host ("LEDGER WARN: {0}" -f $_.Exception.Message) -ForegroundColor Yellow
}

exit 0
