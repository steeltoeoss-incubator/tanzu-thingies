#!/usr/bin/env pwsh -NoProfile

#Requires -Version 7.2

$ErrorActionPreference = "Stop"

. "$PSScriptRoot/../etc/config.ps1"

Log-Header "Installing Tanzu CLI ($TapVersion)"

$CliDist = "$LocalDistDir/tanzu-framework-$PlatformName-amd64-$TapVersion.$PlatformArchive"
If (!(Test-Path "$CliDist"))
{
    Log-Error "Tanzu CLI dist not found: $CliDist"
    Log-Error "see https://github.com/steeltoeoss-incubator/tanzu-thingies#tanzu-cli"
    Die
}

Remove-Item "$TanzuCommand" -ErrorAction SilentlyContinue
$CliDir = "$LocalToolDir/tanzu-framework-$TapVersion"
Remove-Item "$CliDir" -Recurse -ErrorAction SilentlyContinue
New-Item -Path "$CliDir" -ItemType Directory | Out-Null
If ($IsWindows)
{
    unzip "$CliDist" -d "$CliDir" | Out-Null
}
Else
{
    tar xf $CliDist -C $CliDir
}

New-Item -Path $(Split-Path -parent "$TanzuCommand") -ItemType Directory -ErrorAction SilentlyContinue | Out-Null
Copy-Item "$CliDir/cli/core/v*/tanzu-core-${PlatformName}_amd64${PlatformExe}" "$LocalBinDir/tanzu$PlatformExe"
If (!($IsWindows))
{
    chmod +x "$TanzuCommand"
}

Log-Info "installing Tanzu CLI plugins"
Run-Command $TanzuCommand plugin install --local "$CliDir/cli" all

Log-Success "Tanzu CLI installed"
Invoke-Expression "$TanzuCommand version"
