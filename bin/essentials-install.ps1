#!/usr/bin/env pwsh -NoProfile
#Requires -Version 7.2

. "$PSScriptRoot/../etc/config.ps1"

Log-Header "Installing Tanzu Cluster Essentials"

# per : https://tanzu.vmware.com/developer/guides/tanzu-application-platform-local-devloper-install/#stage-3-install-cluster-essentials-for-vmware-tanzu-onto-minikube
K8s-Create-Namespace -Namespace tanzu-cluster-essentials
K8s-Create-Namespace -Namespace kapp-controller

K8s-Apply -Namespace kapp-controller `
    -FileName https://github.com/vmware-tanzu/carvel-kapp-controller/releases/download/v0.34.0/release.yml

K8s-Create-Namespace -Namespace secretgen-controller
K8s-Apply -Namespace secretgen-controller `
    -FileName https://github.com/vmware-tanzu/carvel-secretgen-controller/releases/download/v0.8.0/release.yml

ForEach ($PodNamespace in "kapp-controller", "secretgen-controller")
{
    K8s-Wait-For-Resource -Namespace $PodNamespace -Resource pods -Status "Running"
}

Log-Success "Tanzu Cluster Essentials installed"
