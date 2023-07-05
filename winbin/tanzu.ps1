#!/usr/bin/env pwsh -NoProfile

#Requires -Version 7.2

. "$PSScriptRoot/../etc/config.ps1"

$Cli = Get-ChildItem $LocalOptDir/v*/tanzu-cli-${PlatformName}_amd64${PlatformExe} -ErrorAction SilentlyContinue
if ($Cli -eq $Null) {
    $Cli = Get-ChildItem $LocalOptDir/cli/core/v*/tanzu-core-${PlatformName}_amd64${PlatformExe} -ErrorAction SilentlyContinue
}
if ($Cli -eq $null) {
    Log-Error "TAP $TapVersion CLI dist not found; have you run tanzu-fetch?"
    Die
}

Invoke-Expression "${Cli} ${Args}"
