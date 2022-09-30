#!/usr/bin/env pwsh -NoProfile
#Requires -Version 7.2

. "$PSScriptRoot/../etc/config.ps1"

Log-Header "Deleting minikube cluster"
MiniKube-Delete
Log-Success "minikube cluster deleted"
