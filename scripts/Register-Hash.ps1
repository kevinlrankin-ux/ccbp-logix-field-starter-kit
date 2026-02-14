param(
  [string]$CrPath = "changes/CR-0001"
)

$RepoRoot = Get-Location
$Ledger   = Join-Path $RepoRoot "ledger\hash_registry.jsonl"
$LabelPath = Join-Path $RepoRoot (Join-Path $CrPath "label_oh-01.json")

if (!(Test-Path $LabelPath)) {
  Write-Host "BLOCKED: Missing label_oh-01.json" -ForegroundColor Red
  exit 1
}

$Label = Get-Content $LabelPath -Raw | ConvertFrom-Json
$Hash  = $Label.structure_hash_sha256

$Record = @{
  ts_utc = (Get-Date).ToUniversalTime().ToString("o")
  cr_path = $CrPath
  structure_hash_sha256 = $Hash
}

($Record | ConvertTo-Json -Compress) | Add-Content -Path $Ledger -Encoding UTF8
Write-Host "REGISTERED: $Hash" -ForegroundColor Green
exit 0
