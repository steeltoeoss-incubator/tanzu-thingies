#!/usr/bin/env pwsh -NoProfile

#Requires -Version 7.2

. "$PSScriptRoot/../etc/config.ps1"

kubectl get packageinstall -n $Env:TAP_NAMESPACE tap -o json | jq .status.version
