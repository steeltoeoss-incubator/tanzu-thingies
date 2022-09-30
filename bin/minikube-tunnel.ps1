#!/usr/bin/env pwsh -NoProfile
#Requires -Version 7.2

. "$PSScriptRoot/../etc/config.ps1"

Log-Header "Starting MiniKube cluster tunnel"
If (!((MiniKube-Status) -eq [MiniKubeStatus]::Running))
{
    Die "minikube cluster is not running or is absent"
}
MiniKube-Tunnel
