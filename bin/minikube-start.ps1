#!/usr/bin/env pwsh -NoProfile

#Requires -Version 7.2

. "$PSScriptRoot/../etc/config.ps1"

Log-Header "Starting Minikube cluster"
Run-Command minikube start `
    --driver=$Env:MINIKUBE_DRIVER `
    --kubernetes-version=$Env:MINIKUBE_KUBERNETES_VERSION `
    --cpus=$Env:MINIKUBE_CPUS `
    --memory=$Env:MINIKUBE_MEMORY `
    --disk-size=$Env:MINIKUBE_DISK
Log-Success "Minikube cluster started"
