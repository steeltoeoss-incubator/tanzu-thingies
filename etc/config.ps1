$BaseDir = Resolve-Path "$PSScriptRoot/.."
$BinDir = "$BaseDir/bin"
$ConfigDir = "$BaseDir/etc"
$DataDir = "$BaseDir/share"
$LibDir = "$BaseDir/lib"
$LibExecDir = "$BaseDir/libexec"
$TemplateDir = "$DataDir/templates"
$LocalDir = "$BaseDir/local"
$LocalBinDir = "$LocalDir/bin"
$LocalDistDir = "$LocalDir/distfiles"
$LocalToolDir = "$LocalDir/tools"

. "$LibDir/pwsh-functions.ps1"
. "$LibDir/k8s-functions.ps1"
. "$LibDir/minikube-functions.ps1"
. "$LibDir/pivnet.ps1"

. "$ConfigDir/platform.ps1"
. "$ConfigDir/tap.ps1"
. "$ConfigDir/minikube.ps1"

$Overrides = "$ConfigDir/overrides.ps1"
If (Test-Path "$Overrides")
{
    . "$Overrides"
}

$Credentials = "$ConfigDir/credentials.ps1"
If (!(Test-Path "$credentials"))
{
    Copy-Item "$TemplateDir/credentials.ps1" "$ConfigDir/credentials.ps1"
    Log-Error "credentials.ps1 was not found"
    Log-Error "A template has been copied to:"
    Log-Error "    $ConfigDir/credentials.ps1"
    Log-Error "Edit this file with your credentials before continuing."
    Die
}
. "$Credentials"

$Env:PATH="$LocalBinDir;$Env:PATH"
