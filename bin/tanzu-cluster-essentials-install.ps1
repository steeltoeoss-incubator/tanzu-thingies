#!/usr/bin/env pwsh -NoProfile
#Requires -Version 7.2

. "$PSScriptRoot/../etc/config.ps1"

Log-Header "Installing Tanzu Cluster Essentials ($TanzuClusterEssentialsVersion)"

$PlatformArchive = "tgz"
If ($IsWindows)
{
    $PlatformName = "linux"
}

$EssentialsDist = "$LocalDistDir/tanzu-cluster-essentials-$PlatformName-amd64-$TanzuClusterEssentialsVersion.$PlatformArchive"
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

If ($IsWindows)
{
    Copy-Item $home/.kube/config "$EssentialsDir/kube-config"
    echo "export INSTALL_BUNDLE='$TanzuClusterEssentialsBundle'" > "$EssentialsDir/env"
    echo "export INSTALL_REGISTRY_HOSTNAME=$TanzuNetHost" >> "$EssentialsDir/env"
    echo "export INSTALL_REGISTRY_USERNAME='$TanzuNetUser'" >> "$EssentialsDir/env"
    echo "export INSTALL_REGISTRY_PASSWORD='$TanzuNetPass'" >> "$EssentialsDir/env"
    bash $(Windows-2-Unix "$LibExecDir/essentials-install-via-winbash.sh") `
        $(Windows-2-Unix "$EssentialsDir")
}
Else
{
    Set-Location $EssentialsDir
    $Env:INSTALL_BUNDLE = $TanzuClusterEssentialsBundle
    $Env:INSTALL_REGISTRY_HOSTNAME = $TanzuNetHost
    $Env:INSTALL_REGISTRY_USERNAME = $TanzuNetUser
    $Env:INSTALL_REGISTRY_PASSWORD = $TanzuNetPass
    Run-Command ./install.sh --yes
}

ForEach ($PodNamespace in "kapp-controller", "secretgen-controller")
{
    K8s-Wait-For-Resource -Namespace $PodNamespace -Resource pods -Status "Running"
}

Log-Success "Tanzu Cluster Essentials installed"
