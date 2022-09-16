#!/usr/bin/env pwsh -NoProfile

#Requires -Version 7.2

. "$PSScriptRoot/../etc/config.ps1"

Log-Header "Deleting Minikube cluster"
Run-Command minikube delete
Log-Success "Minikube cluster deleted"
