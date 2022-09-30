#!/usr/bin/env pwsh -NoProfile
#Requires -Version 7.2

. "$PSScriptRoot/../etc/config.ps1"

Log-Header "Starting minikube cluster"
If ((MiniKube-Status) -eq [MiniKubeStatus]::Stopped)
{
    MiniKube-Start
}
else
{
    Die "minikube cluster is running or is absent"
}
Log-Success "minikube cluster started"
