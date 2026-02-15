param(
  [Parameter(Mandatory=$true)] [string]$RepoRoot,
  [Parameter(Mandatory=$true)] $Record,
  [Parameter(Mandatory=$true)] [string]$CanonicalJson,
  [Parameter(Mandatory=$true)] [string]$EntryHash
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# ENTERPRISE sink router (STUB)
# This file is intentionally safe-by-default:
# - no network calls unless explicitly enabled in governance.settings.json (future)
# - no credentials stored in repo (future)
# - emits only local placeholder output

$SettingsPath = Join-Path $RepoRoot "governance\governance.settings.json"
if (!(Test-Path $SettingsPath)) { throw "Missing settings: $SettingsPath" }
$Settings = Get-Content $SettingsPath -Raw | ConvertFrom-Json

# Example shape for future:
# $Settings.enterprise.sinks.sql.enabled
# $Settings.enterprise.sinks.rest.enabled
# $Settings.enterprise.sinks.siem.enabled

# Placeholder: write a local “enterprise outbox” file (safe, offline)
$outDir = Join-Path $RepoRoot "ledger\enterprise_outbox"
if (!(Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir | Out-Null }
$out = Join-Path $outDir ("evt_" + (Get-Date).ToUniversalTime().ToString("yyyyMMdd_HHmmssfff") + "Z_" + $EntryHash + ".json")

@{
  entry_hash_sha256 = $EntryHash
  ts_utc = (Get-Date).ToUniversalTime().ToString("o")
  record = $Record
  canonical_json = $CanonicalJson
} | ConvertTo-Json -Depth 12 | Set-Content -Path $out -Encoding UTF8

Write-Host ("ENTERPRISE ROUTER OK: wrote outbox {0}" -f $out) -ForegroundColor Cyan
exit 0
