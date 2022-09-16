#!/usr/bin/env pwsh -NoProfile

#Requires -Version 7.2

. "$PSScriptRoot/../etc/config.ps1"

Log-Header "Starting MiniKube cluster"
Run-Command $MiniKubeCommand start `
    --driver=$MiniKubeDriver `
    --kubernetes-version=$MiniKubeKubernetesVersion `
    --cpus=$MiniKubeCpus `
    --memory=$MiniKubeMemory `
    --disk-size=$MiniKubeDisk
Log-Success "MiniKube cluster started"
