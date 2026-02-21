Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Get-CCBPSha256 {
  param([Parameter(Mandatory=$true)][string]$Path)
  if (-not (Test-Path $Path)) { return $null }
  (Get-FileHash -Path $Path -Algorithm SHA256).Hash.ToLowerInvariant()
}

function New-CCBPDir {
  param([Parameter(Mandatory=$true)][string]$Path)
  if (-not (Test-Path $Path)) { New-Item -ItemType Directory -Path $Path | Out-Null }
}

Export-ModuleMember -Function Get-CCBPSha256, New-CCBPDir
