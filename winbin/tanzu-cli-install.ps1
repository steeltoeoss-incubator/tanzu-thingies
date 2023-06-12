#!/usr/bin/env pwsh -NoProfile

#Requires -Version 7.2

. "$PSScriptRoot/../etc/config.ps1"

Log-Header "Installing TAP $TapVersion CLI"

if ($IsWindows) {
    $archive = "zip"
} else {
    $archive = "tar"
}

$CliDist = Get-ChildItem $LocalCacheDir -Filter tanzu-framework-$PlatformName-amd64-*.$archive -ErrorAction SilentlyContinue
if ($CliDist -eq $null) {
    Log-Error "TAP $TapVersion CLI dist not found; have you run tanzu-fetch?"
    Die
}

Remove-Item "$LocalOptDir" -Recurse -ErrorAction SilentlyContinue
New-Item -Path "$LocalOptDir" -ItemType Directory | Out-Null
Extract -Archive "$CliDist" -OutDir "$LocalOptDir"

Log-Info "installing Tanzu CLI plugins"
Run-Command $LocalOptDir/cli/core/v*/tanzu-core-${PlatformName}_amd64${PlatformExe} plugin install --local "$LocalOptDir/cli" all
Log-Info "Tanzu CLI version"
Run-Command $LocalOptDir/cli/core/v*/tanzu-core-${PlatformName}_amd64${PlatformExe} version
Log-Info "Tanzu CLI apps version"
Run-Command $LocalOptDir/cli/core/v*/tanzu-core-${PlatformName}_amd64${PlatformExe} apps version

Log-Success "Tanzu CLI installed"
