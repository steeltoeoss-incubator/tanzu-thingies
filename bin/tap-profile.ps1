#!/usr/bin/env pwsh -NoProfile

#Requires -Version 7.2

. "$PSScriptRoot\..\etc\config.ps1"

envsubst `
    -i "$Env:DATA_DIR\examples\tap-profile.yaml" `
    -o "$Env:CONFIG_DIR\tap-profile.yaml"
