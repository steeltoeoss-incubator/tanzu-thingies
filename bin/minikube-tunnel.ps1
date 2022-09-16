#!/usr/bin/env pwsh -NoProfile

#Requires -Version 7.2

. "$PSScriptRoot/../etc/config.ps1"

Log-Header "Starting Minikube cluster tunnel"
Run-Command minikube tunnel
