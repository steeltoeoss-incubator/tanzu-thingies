#!/usr/bin/env pwsh -NoProfile
#Requires -Version 7.2

. "$PSScriptRoot/../etc/config.ps1"

Log-Header "Installing Tanzu Cluster Essentials ($TanzuClusterEssentialsVersion)"

$EssentialsDist = "$LocalDistDir/tanzu-cluster-essentials-$PlatformName-amd64-$TanzuClusterEssentialsVersion.tgz"
If (!(Test-Path "$EssentialsDist"))
{
    Log-Error "Tanzu Cluster Essentials dist not found: $EssentialsDist"
    Log-Error "see https://github.com/steeltoeoss-incubator/tanzu-thingies#tanzu-cluster-essentials"
    Die
}

$EssentialsDir = "$LocalToolDir/tanzu-cluster-essentials-$TanzuClusterEssentialsVersion"
Remove-Item "$EssentialsDir" -Recurse -ErrorAction SilentlyContinue
New-Item -Path "$EssentialsDir" -ItemType Directory -ErrorAction SilentlyContinue | Out-Null
Extract -Archive "$EssentialsDist" -OutDir "$EssentialsDir"

$Env:INSTALL_BUNDLE = $TanzuClusterEssentialsBundle
$Env:INSTALL_REGISTRY_HOSTNAME = $TanzuNetHost
$Env:INSTALL_REGISTRY_USERNAME = $TanzuNetUser
$Env:INSTALL_REGISTRY_PASSWORD = $TanzuNetPass
$workDir = Get-Location
Set-Location $EssentialsDir
Run-Command ".\$(($IsWindows) ? "install.bat" : "install.sh")" --yes
Set-Location $workDir

ForEach ($PodNamespace in "kapp-controller", "secretgen-controller")
{
    K8s-Wait-For-Resource -Namespace $PodNamespace -Resource pods -Status "Running"
}

Log-Success "Tanzu Cluster Essentials installed"
