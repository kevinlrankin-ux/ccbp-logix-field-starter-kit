

# ------------------------------------------------
# AUTO_LEDGER_APPEND: append stamp + hash to ledger/hash_registry.jsonl
# (EOF-safe; best-effort variable capture)
# ------------------------------------------------
try {
  if (-not $RepoRoot -or $RepoRoot -eq "") { $RepoRoot = Get-Location }

  $LedgerDir  = Join-Path $RepoRoot "ledger"
  if (!(Test-Path $LedgerDir)) { New-Item -ItemType Directory -Path $LedgerDir | Out-Null }

  $LedgerPath = Join-Path $LedgerDir "hash_registry.jsonl"
  if (!(Test-Path $LedgerPath)) { New-Item -ItemType File -Path $LedgerPath | Out-Null }

  $Record = @{
    ts_utc = (Get-Date).ToUniversalTime().ToString("o")
    scope  = "REAL"
    cr_path = (Get-Variable -Name CrPath -ErrorAction SilentlyContinue).Value
    structure_hash_sha256 = (Get-Variable -Name Hash -ErrorAction SilentlyContinue).Value
    approver = (Get-Variable -Name Approver -ErrorAction SilentlyContinue).Value
    stamp_path = (Get-Variable -Name StampPath -ErrorAction SilentlyContinue).Value
  }

  ($Record | ConvertTo-Json -Compress) | Add-Content -Path $LedgerPath -Encoding UTF8
  Write-Host "LEDGER APPENDED: $LedgerPath" -ForegroundColor Cyan
} catch {
  Write-Host ("LEDGER WARN: failed to append ({0})" -f $_.Exception.Message) -ForegroundColor Yellow
}
# AUTO_LEDGER_APPEND

