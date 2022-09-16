#!/usr/bin/env pwsh -NoProfile

#Requires -Version 7.2

$ErrorActionPreference = "Stop"

. "$PSScriptRoot/../etc/config.ps1"

Log-Header "Installing Tanzu CLI ($Env:TAP_VERSION)"

$cli_dist = "$Env:LOCAL_DIST_DIR/tanzu-framework-$Env:PLATFORM-amd64-$Env:TAP_VERSION.$Env:ARCHIVE"
if (!(Test-Path "$cli_dist"))
{
    log-error "Tanzu CLI dist not found: $cli_dist"
    log-error "see https://github.com/steeltoeoss-incubator/tanzu-thingies#tanzu-cli"
    Die
}

Remove-Item "$Env:TANZU_CMD" -ErrorAction SilentlyContinue
$cli_dir = "$Env:LOCAL_TOOL_DIR/tanzu-framework-$Env:TAP_VERSION"
Remove-Item "$cli_dir" -Recurse -ErrorAction SilentlyContinue
New-Item -Path "$cli_dir" -ItemType Directory | Out-Null
if ($IsWindows)
{
    unzip "$cli_dist" -d "$cli_dir" | Out-Null
}
else
{
    tar xf $cli_dist -C $cli_dir
}

New-Item -Path $(Split-Path -parent "$Env:TANZU_CMD") -ItemType Directory -ErrorAction SilentlyContinue | Out-Null
Copy-Item "$cli_dir\cli\core\v*\tanzu-core-${Env:PLATFORM}_amd64${Env:EXECUTABLE}" "$Env:LOCAL_BIN_DIR\tanzu${Env:EXECUTABLE}"
if (!($IsWindows))
{
    chmod +x "$Env:TANZU_CMD"
}

Log-Info "displaying Tanzu CLI version"
Run-Command $Env:TANZU_CMD version

Log-Info "installing Tanzu CLI plugins"
Run-Command $Env:TANZU_CMD plugin install --local "$cli_dir/cli" all

Log-Header "Tanzu CLI installed"
