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

$LocalEnv = @{
    XDG_CONFIG_HOME = "$LocalConfigDir"
    XDG_DATA_HOME = "$LocalDataDir"
    XDG_CACHE_HOME = "$LocalCacheDir"
}
Start-Process "${Cli} ${Args}" -Environment $LocalEnv
