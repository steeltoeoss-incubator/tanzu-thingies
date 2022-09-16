#!/usr/bin/env pwsh -NoProfile

#Requires -Version 7.2

. "$PSScriptRoot/../etc/config.ps1"

Log-Header "Stopping Minikube cluster"
Run-Command minikube stop
Log-Success "Minikube cluster stopped"
