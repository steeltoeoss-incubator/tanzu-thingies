#!/usr/bin/env pwsh -NoProfile
#Requires -Version 7.2

$ErrorActionPreference = "Stop"

. "$PSScriptRoot/../etc/config.ps1"

Log-Header "Installing Tanzu CLI ($TapVersion)"

if ($IsWindows) {
    $archive = "zip"
} else {
    $archive = "tar"
}
$CliDist = Get-ChildItem $LocalDistDir/$TapVersion -Filter tanzu-framework-$PlatformName-amd64-*.$archive
if ($CliDist -eq $null) {
    Log-Error "Tanzu CLI dist not found: $CliDist"
    Log-Error "see https://github.com/steeltoeoss-incubator/tanzu-thingies#tanzu-cli"
    Die
}

$ToolDir = "$LocalToolDir/$TapVersion"
Remove-Item "$ToolDir" -Recurse -ErrorAction SilentlyContinue
New-Item -Path "$ToolDir" -ItemType Directory | Out-Null
Extract -Archive "$CliDist" -OutDir "$ToolDir"

Log-Info "installing Tanzu CLI plugins"
Run-Command $ToolDir/cli/core/v*/tanzu-core-${PlatformName}_amd64${PlatformExe} plugin install --local "$ToolDir/cli" all
Run-Command $ToolDir/cli/core/v*/tanzu-core-${PlatformName}_amd64${PlatformExe} version
Run-Command $ToolDir/cli/core/v*/tanzu-core-${PlatformName}_amd64${PlatformExe} apps version

Log-Success "Tanzu CLI installed"
