param(
  [Parameter(Mandatory=$true)]
  [ValidateSet("validate","build","pack")]
  [string]$Command
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$RepoRoot = (git rev-parse --show-toplevel) 2>$null
if (-not $RepoRoot) { throw "CCBP: repo root not found (git rev-parse failed)." }

Import-Module "$PSScriptRoot\lib\CLP.psm1" -Force
Import-Module "$PSScriptRoot\lib\IO.psm1" -Force
Import-Module "$PSScriptRoot\lib\Contracts.psm1" -Force
Import-Module "$PSScriptRoot\lib\Asp.psm1" -Force
Import-Module "$PSScriptRoot\lib\Validate.psm1" -Force
Import-Module "$PSScriptRoot\lib\Sag.psm1" -Force
Import-Module "$PSScriptRoot\lib\Package.psm1" -Force

$Contract = Get-CCBPContractIndex -RepoRoot $RepoRoot
$AspPosture = Get-ASPPosture -RepoRoot $RepoRoot -Contract $Contract

switch ($Command) {
  "validate" { Invoke-CCBPValidate -RepoRoot $RepoRoot -Contract $Contract -AspPosture $AspPosture }
  "build"    { Invoke-CCBPBuild    -RepoRoot $RepoRoot -Contract $Contract -AspPosture $AspPosture }
  "pack"     { Invoke-CCBPPack     -RepoRoot $RepoRoot -Contract $Contract -AspPosture $AspPosture }
}
