#!/usr/bin/env pwsh -NoProfile

#Requires -Version 7.2

. "$PSScriptRoot/../etc/config.ps1"

Log-Header "Installing TAP $TapVersion CLI"

if ($IsWindows) {
    $archive = "zip"
} else {
    $archive = "tar"
}

$CliDist = Get-ChildItem $LocalDownloadDir -Filter tanzu-cli-$PlatformName-amd64.$archive -ErrorAction SilentlyContinue
if ($CliDist -eq $null) {
    $LegacyCli = $True
    $CliDist = Get-ChildItem $LocalDownloadDir -Filter tanzu-framework-$PlatformName-amd64-*.$archive -ErrorAction SilentlyContinue
}
else {
    $LegacyCli = $False
}
if ($CliDist -eq $null) {
    Log-Error "TAP $TapVersion CLI dist not found; have you run tanzu-fetch?"
    Die
}

Remove-Item "$LocalOptDir" -Recurse -ErrorAction SilentlyContinue
New-Item -Path "$LocalOptDir" -ItemType Directory | Out-Null
Extract -Archive "$CliDist" -OutDir "$LocalOptDir"

$Cli = Get-ChildItem $LocalOptDir/v*/tanzu-cli-${PlatformName}_amd64${PlatformExe} -ErrorAction SilentlyContinue
if ($Cli -eq $Null) {
    $Cli = Get-ChildItem $LocalOptDir/cli/core/v*/tanzu-core-${PlatformName}_amd64${PlatformExe} -ErrorAction SilentlyContinue
}

Log-Info "installing Tanzu CLI plugins"
if ($LegacyCli) {
    Run-Command $Cli plugin install --local "$LocalOptDir/cli" all
}
else {
    Run-Command $Cli config eula accept
    Run-Command $Cli config set env.TANZU_CLI_ADDITIONAL_PLUGIN_DISCOVERY_IMAGES_TEST_ONLY harbor-repo.vmware.com/tanzu_cli_stage/plugins/plugin-inventory:latest
    Run-Command $Cli plugin install --group vmware-tap/default:1.6.0-rc.1
}

Log-Info "Tanzu CLI version"
Run-Command $Cli version
Log-Info "Tanzu CLI apps version"
Run-Command $Cli apps version

Log-Success "Tanzu CLI installed"
