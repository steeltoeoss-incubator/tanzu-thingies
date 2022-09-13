#!/usr/bin/env pwsh

. "$PSScriptRoot\..\etc\config.ps1"

kubectl get packageinstall -n $Env:TAP_NAMESPACE tap -o json | jq .status.version
