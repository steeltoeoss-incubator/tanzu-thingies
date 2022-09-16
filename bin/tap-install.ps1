#!/usr/bin/env pwsh -NoProfile

#Requires -Version 7.2


$ErrorActionPreference = "Stop"

. "$PSScriptRoot/../etc/config.ps1"

Log-Header "Installing TAP ($Env:TAP_VERSION)"

Invoke-Expression "$Env:BIN_DIR\tanzu-cli-install.ps1"
Invoke-Expression "$Env:BIN_DIR\essentials-install.ps1"

K8s-Create-Namespace $Env:TAP_NAMESPACE

Log-Info "adding tap-registry credentials ($Env:TAP_NAMESPACE)"
Invoke-Expression "$Env:TANZU_CMD secret registry add tap-registry --server $Env:TANZUNET_HOST --username $Env:TANZUNET_USER --password '$Env:TANZUNET_PASS' --namespace $Env:TAP_NAMESPACE --export-to-all-namespaces --yes"

Log-Info "adding registry credentials ($Env:TAP_NAMESPACE)"
Invoke-Expression "$Env:TANZU_CMD secret registry add registry-credentials --server $Env:REGISTRY_HOST --username $Env:REGISTRY_USER --password '$Env:REGISTRY_PASS' --namespace $Env:TAP_NAMESPACE"

Log-Info "adding repository"
Run-Command $Env:TANZU_CMD package repository add tanzu-tap-repository --url $Env:TANZUNET_HOST/tanzu-application-platform/tap-packages:$Env:TAP_VERSION --namespace $Env:TAP_NAMESPACE

Log-Info "checking repository status"
Run-Command $Env:TANZU_CMD package repository get tanzu-tap-repository --namespace $Env:TAP_NAMESPACE

Log-Info "listing packages"
Run-Command $Env:TANZU_CMD package available list --namespace $Env:TAP_NAMESPACE

Log-Info "installing TAP (this may take a while)"
$tap_profile = "$Env:CONFIG_DIR/tap-profile.yaml"
if (!(Test-Path "$tap_profile"))
{
    log-error "TAP profile not found: $tap_profile"
    log-error "see https://github.com/steeltoeoss-incubator/tanzu-thingies#tap-profile"
    Die
}

Run-Command $Env:TANZU_CMD package install tap -p tap.tanzu.vmware.com -v $Env:TAP_VERSION --values-file "$tap_profile" --poll-timeout 45m --namespace $Env:TAP_NAMESPACE

Log-Header "Creating Developer Environment"

K8s-Create-Namespace $Env:TAP_DEV_NAMESPACE

Log-Info "adding registry credentials ($Env:TAP_DEV_NAMESPACE)"
Invoke-Expression "$Env:TANZU_CMD secret registry add registry-credentials --server $Env:REGISTRY_HOST --username $Env:REGISTRY_USER --password '$Env:REGISTRY_PASS' --namespace $Env:TAP_DEV_NAMESPACE"

Log-Info "adding service roles"
Run-Command kubectl -n $Env:TAP_DEV_NAMESPACE apply -f "$Env:CONFIG_DIR/serviceaccounts.yaml"

Log-Header "Installed TAP ($Env:TAP_VERSION)"
