#!/usr/bin/env pwsh -NoProfile

#Requires -Version 7.2

$ErrorActionPreference = "Stop"

. "$PSScriptRoot/../etc/config.ps1"

# Tanzu CLI and Plugins
$slug = $TapSlug
$release = $TapVersion
$platform = $PlatformName
If ($IsWindows)
{
    $archive = "zip"
}
Else
{
    $archive = "tar"
}
Pivnet-Download -Slug $slug -Release $release -Platform $platform
Log-Crumb "renaming dist to include release version"
Move-Item -Force "$LocalDistDir/tanzu-framework-$platform-amd64.$archive" $LocalDistDir/tanzu-framework-$platform-amd64-$release.$archive

# Tanzu Cluster Essentials
$slug = $TanzuClusterEssentialsSlug
$release = $TanzuClusterEssentialsVersion
If ($IsWindows)
{
    $platform = "linux"
}
Else
{
    $platform = $PlatformName
}
Pivnet-Download -Slug $slug -Release $release -Platform $platform
