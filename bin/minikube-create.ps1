#!/usr/bin/env pwsh -NoProfile
#Requires -Version 7.2

Param
(
    [switch]$WithStop = $False
)

$ErrorActionPreference = "Stop"

. "$PSScriptRoot/../etc/config.ps1"

If (!((MiniKube-Status) -eq [MiniKubeStatus]::Absent))
{
    Die "minikube cluster is already created"
}
MiniKube-Create
If ($WithStop)
{
    MiniKube-Stop
}
