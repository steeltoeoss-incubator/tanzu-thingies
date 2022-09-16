#!/usr/bin/env pwsh -NoProfile

#Requires -Version 7.2

. "$PSScriptRoot/../etc/config.ps1"

Log-Header "Installing Tanzu Cluster Essentials"

# per : https://tanzu.vmware.com/developer/guides/tanzu-application-platform-local-devloper-install/#stage-3-install-cluster-essentials-for-vmware-tanzu-onto-minikube
Run-Command kubectl create namespace tanzu-cluster-essentials
Run-Command kubectl create namespace kapp-controller
Run-Command kubectl create namespace secretgen-controller
Run-Command kubectl apply -f https://github.com/vmware-tanzu/carvel-kapp-controller/releases/download/v0.34.0/release.yml -n kapp-controller
Run-Command kubectl apply -f https://github.com/vmware-tanzu/carvel-secretgen-controller/releases/download/v0.8.0/release.yml -n secretgen-controller

$count = 0
While ($true)
{
    $not_running = kubectl get pods -n kapp-controller --no-headers | Select-String "Running" -NotMatch
    if (!($not_running))
    {
        Break
    }
    ++$count
    Log-Crumb "waiting for all kapp-controller to be running [$count]"
    Start-Sleep -s 1
}

$count = 0
While ($true)
{
    $not_running = kubectl get pods -n secretgen-controller --no-headers | Select-String "Running" -NotMatch
    if (!($not_running))
    {
        Break
    }
    ++$count
    Log-Crumb "waiting for all secretgen-controller to be running [$count]"
    Start-Sleep -s 1
}

Log-Success "Tanzu Cluster Essentials installed"
