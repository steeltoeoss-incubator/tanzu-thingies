#!/usr/bin/env pwsh -NoProfile

#Requires -Version 7.2

$ErrorActionPreference = "Stop"

. "$PSScriptRoot/../etc/config.ps1"

Log-Header "Installing TAP ($TapVersion)"

$TapProfile = "$ConfigDir/tap-profile.yaml"
If (!(Test-Path "$TapProfile"))
{
    Log-Error "TAP profile not found: $TapProfile"
    Log-Error "see https://github.com/steeltoeoss-incubator/tanzu-thingies#tap-profile"
    Die
}

Invoke-Expression "$BinDir/tanzu-cli-install.ps1"
Invoke-Expression "$BinDir/tanzu-cluster-essentials-install.ps1"

K8s-Create-Namespace $TapNamespace

Log-Info "adding tap-registry credentials ($TapNamespace)"
Invoke-Expression "$TanzuCommand secret registry add tap-registry --server $TanzuNetHost --username $TanzuNetUser --password '$TanzuNetPass' --namespace $TapNamespace --export-to-all-namespaces --yes"

Log-Info "adding registry credentials ($TapNamespace)"
Invoke-Expression "$TanzuCommand secret registry add registry-credentials --server $RegistryHost --username $RegistryUser --password '$RegistryPass' --namespace $TapNamespace"

Log-Info "adding repository"
Run-Command $TanzuCommand package repository add tanzu-tap-repository --url $TanzuNetHost/tanzu-application-platform/tap-packages:$TapVersion --namespace $TapNamespace

Log-Info "checking repository status"
Run-Command $TanzuCommand package repository get tanzu-tap-repository --namespace $TapNamespace

Log-Info "listing packages"
Run-Command $TanzuCommand package available list --namespace $TapNamespace

Log-Info "installing TAP (this may take a while)"

Run-Command $TanzuCommand package install tap -p tap.tanzu.vmware.com -v $TapVersion --values-file "$TapProfile" --poll-timeout 45m --namespace $TapNamespace
$Count = 0
K8s-Wait-For-Resource -Namespace $TapNamespace -Resource packageinstall/tap -Status "Reconcile succeeded"

Log-Header "Creating Developer Environment"

K8s-Create-Namespace $TapDevNamespace

Log-Info "adding registry credentials ($TapDevNamespace)"
Invoke-Expression "$TanzuCommand secret registry add registry-credentials --server $RegistryHost --username $RegistryUser --password '$RegistryPass' --namespace $TapDevNamespace"

Log-Info "adding service roles"
Run-Command kubectl -n $TapDevNamespace apply -f "$ConfigDir/serviceaccounts.yaml"

Log-Success "TAP installed"
Invoke-Expression "$BinDir/tap-version.ps1"
