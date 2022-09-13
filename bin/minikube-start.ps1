#!/usr/bin/env pwsh

. "$PSScriptRoot\..\etc\config.ps1"

minikube start `
    --driver=$Env:MINIKUBE_DRIVER `
    --kubernetes-version=$Env:MINIKUBE_KUBERNETES_VERSION `
    --cpus=$Env:MINIKUBE_CPUS `
    --memory=$Env:MINIKUBE_MEMORY `
    --disk-size=$Env:MINIKUBE_DISK
