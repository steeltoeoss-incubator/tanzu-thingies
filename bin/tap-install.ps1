#!/usr/bin/env pwsh -NoProfile

#Requires -Version 7.2


$ErrorActionPreference = "Stop"

. "$PSScriptRoot/../etc/config.ps1"

Log-Header "Installing TAP ($Env:TAP_VERSION)"

Log-Message "installing Tanzu CLI"
$cli_dist = "$Env:LOCAL_DIST_DIR/tanzu-framework-$Env:PLATFORM-amd64-$Env:TAP_VERSION.$Env:ARCHIVE"
if (!(Test-Path "$cli_dist"))
{
    log-error "Tanzu CLI dist not found: $cli_dist"
    log-error "see https://github.com/steeltoeoss-incubator/tanzu-thingies#tanzu-cli"
    Die
}

Remove-Item "$Env:TANZU_CMD" -ErrorAction SilentlyContinue
$cli_dir = "$Env:LOCAL_TOOL_DIR/tanzu-framework-$Env:TAP_VERSION"
Remove-Item "$cli_dir" -Recurse -ErrorAction SilentlyContinue
New-Item -Path "$cli_dir" -ItemType Directory | Out-Null
if ($IsWindows)
{
    unzip "$cli_dist" -d "$cli_dir" | Out-Null
}
else
{
    tar xf $cli_dist -C $cli_dir
}
New-Item -Path $(Split-Path -parent "$Env:TANZU_CMD") -ItemType Directory -ErrorAction SilentlyContinue | Out-Null
Copy-Item "$cli_dir\cli\core\v*\tanzu-core-${Env:PLATFORM}_amd64${Env:EXECUTABLE}" "$Env:LOCAL_BIN_DIR\tanzu${Env:EXECUTABLE}"
if (!($IsWindows))
{
    chmod +x "$Env:TANZU_CMD"
}
Run-Command $Env:TANZU_CMD version

Log-Message "installing Tanzu CLI plugins"
Run-Command $Env:TANZU_CMD plugin install --local "$cli_dir/cli" all

Log-Message "installing Tanzu Cluster Essentials"
# per : https://tanzu.vmware.com/developer/guides/tanzu-application-platform-local-devloper-install/#stage-3-install-cluster-essentials-for-vmware-tanzu-onto-minikube
Run-Command kubectl create namespace tanzu-cluster-essentials
Run-Command kubectl create namespace kapp-controller
Run-Command kubectl create namespace secretgen-controller
Run-Command kubectl apply -f https://github.com/vmware-tanzu/carvel-kapp-controller/releases/download/v0.34.0/release.yml -n kapp-controller
Run-Command kubectl apply -f https://github.com/vmware-tanzu/carvel-secretgen-controller/releases/download/v0.8.0/release.yml -n secretgen-controller

Write-Host
Write-Host "=====================================================" -Foreground Blue
Write-Host "                User Action Required" -Foreground Blue
Write-Host "-----------------------------------------------------" -Foreground Blue
Write-Host
Write-Host "In separate terminal, run:" -Foreground Cyan
Write-Host
Write-Host "    kubectl get pods --all-namespaces" -Foreground Cyan
Write-Host
Write-Host "When all pods in Running state, hit ENTER to continue" -Foreground Cyan
Write-Host
Write-Host "=====================================================" -Foreground Blue
Write-Host
Pause

K8s-Create-Namespace $Env:TAP_NAMESPACE

Log-Message "adding tap-registry credentials ($Env:TAP_NAMESPACE)"
Invoke-Expression "$Env:TANZU_CMD secret registry add tap-registry --server $Env:TANZUNET_HOST --username $Env:TANZUNET_USER --password '$Env:TANZUNET_PASS' --namespace $Env:TAP_NAMESPACE --export-to-all-namespaces --yes"

Log-Message "adding registry credentials ($Env:TAP_NAMESPACE)"
Invoke-Expression "$Env:TANZU_CMD secret registry add registry-credentials --server $Env:REGISTRY_HOST --username $Env:REGISTRY_USER --password '$Env:REGISTRY_PASS' --namespace $Env:TAP_NAMESPACE"

Log-Message "adding repository"
Run-Command $Env:TANZU_CMD package repository add tanzu-tap-repository --url $Env:TANZUNET_HOST/tanzu-application-platform/tap-packages:$Env:TAP_VERSION --namespace $Env:TAP_NAMESPACE

Log-Message "checking repository status"
Run-Command $Env:TANZU_CMD package repository get tanzu-tap-repository --namespace $Env:TAP_NAMESPACE

Log-Message "listing packages"
Run-Command $Env:TANZU_CMD package available list --namespace $Env:TAP_NAMESPACE

Log-Message "installing TAP (this may take a while)"
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

Log-Message "adding registry credentials ($Env:TAP_DEV_NAMESPACE)"
Invoke-Expression "$Env:TANZU_CMD secret registry add registry-credentials --server $Env:REGISTRY_HOST --username $Env:REGISTRY_USER --password '$Env:REGISTRY_PASS' --namespace $Env:TAP_DEV_NAMESPACE"

Log-Message "adding service roles"
Run-Command kubectl -n $Env:TAP_DEV_NAMESPACE apply -f "$Env:CONFIG_DIR/serviceaccounts.yaml"

Log-Header "Installed TAP ($Env:TAP_VERSION)"
