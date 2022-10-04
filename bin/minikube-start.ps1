#!/usr/bin/env pwsh -NoProfile
#Requires -Version 7.2

. "$PSScriptRoot/../etc/config.ps1"

If ((MiniKube-Status) -eq [MiniKubeStatus]::Absent)
{
    Die "minikube cluster is absent"
}
If ((MiniKube-Status) -eq [MiniKubeStatus]::Running)
{
    Log-Info "minikube cluster is already running"
    Exit
}
MiniKube-Start
