#!/usr/bin/env pwsh

. "$PSScriptRoot\..\etc\config.ps1"
. "$Env:LIBEXEC_DIR\k8s-functions.ps1"

log-header "installing TAP ($Env:TAP_VERSION)"

log-message "installing Tanzu CLI"
$cli_dist = "$Env:LOCAL_DIST_DIR\tanzu-framework-$Env:PLATFORM-amd64-$Env:TAP_VERSION.zip"
if (!(Test-Path "$cli_dist"))
{
    log-error "Tanzu CLI dist not found: $cli_dist"
    log-error "see https://github.com/steeltoeoss-incubator/tanzu-thingies#tanzu-cli"
    throw
}
Remove-Item "$Env:LOCAL_BIN_DIR\tanzu" -ErrorAction SilentlyContinue
$cli_dir = "$Env:LOCAL_TOOL_DIR\tanzu-framework-$Env:TAP_VERSION"
Remove-Item "$cli_dir" -Recurse -ErrorAction SilentlyContinue
mkdir "$cli_dir" | Out-Null
unzip "$cli_dist" -d "$cli_dir" | Out-Null
if (!(Test-Path "$Env:LOCAL_BIN_DIR"))
{
    mkdir "$Env:LOCAL_BIN_DIR" | Out-Null
}
copy "$cli_dir\cli\core\v*\tanzu-core-${Env:PLATFORM}_amd64.exe" "$Env:LOCAL_BIN_DIR\tanzu.exe"
tanzu version

log-message "installing Tanzu CLI plugins"
tanzu plugin install --local "$cli_dir\cli" all

log-message "installing Tanzu Cluster Essentials"
# per : https://tanzu.vmware.com/developer/guides/tanzu-application-platform-local-devloper-install/#stage-3-install-cluster-essentials-for-vmware-tanzu-onto-minikube
kubectl create namespace tanzu-cluster-essentials
kubectl create namespace kapp-controller
kubectl create namespace secretgen-controller
kubectl apply -f https://github.com/vmware-tanzu/carvel-kapp-controller/releases/download/v0.34.0/release.yml -n kapp-controller
kubectl apply -f https://github.com/vmware-tanzu/carvel-secretgen-controller/releases/download/v0.8.0/release.yml -n secretgen-controller

log-message "checking kapp-controller, secretgen-controller"
kubectl get pods --all-namespaces | Select-String "controller"

create-namespace $Env:TAP_NAMESPACE

log-message "adding tap-registry credentials ($Env:TAP_NAMESPACE)"

tanzu secret registry add tap-registry --server $Env:TANZUNET_HOST --username $Env:TANZUNET_USER --password $Env:TANZUNET_PASS --namespace $Env:TAP_NAMESPACE --export-to-all-namespaces --yes

log-message "adding registry credentials ($Env:TAP_NAMESPACE)"
tanzu secret registry add registry-credentials --server $Env:REGISTRY_HOST --username $Env:REGISTRY_USER --password $Env:REGISTRY_PASS --namespace $Env:TAP_NAMESPACE

log-message "adding repository"
tanzu package repository add tanzu-tap-repository --url $Env:TANZUNET_HOST/tanzu-application-platform/tap-packages:$Env:TAP_VERSION --namespace $Env:TAP_NAMESPACE

log-message "checking repository status"
tanzu package repository get tanzu-tap-repository --namespace $Env:TAP_NAMESPACE

log-message "listing packages"
tanzu package available list --namespace $Env:TAP_NAMESPACE

log-message "installing TAP (this may take a while)"
$tap_profile = "$Env:CONFIG_DIR\tap-profile.yaml"
if (!(Test-Path "$tap_profile"))
{
    log-error "TAP profile not found: $tap_profile"
    log-error "see https://github.com/steeltoeoss-incubator/tanzu-thingies#tap-profile"
    throw
}

tanzu package install tap -p tap.tanzu.vmware.com -v $Env:TAP_VERSION --values-file "$tap_profile" --poll-timeout 45m --namespace $Env:TAP_NAMESPACE

log-header "creating developer environment"

create-namespace $Env:TAP_DEV_NAMESPACE

log-message "adding registry credentials ($Env:TAP_DEV_NAMESPACE)"
tanzu secret registry add registry-credentials --server $Env:REGISTRY_HOST --username $Env:REGISTRY_USER --password $Env:REGISTRY_PASS --namespace $Env:TAP_DEV_NAMESPACE

log-message "adding service roles"
kubectl -n $Env:TAP_DEV_NAMESPACE apply -f "$Env:CONFIG_DIR\serviceaccounts.yaml"
