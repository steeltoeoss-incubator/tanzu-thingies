$Env:BASE_DIR = Resolve-Path "$PSScriptRoot\.."
$Env:BIN_DIR = "$Env:BASE_DIR\bin"
$Env:CONFIG_DIR = "$Env:BASE_DIR\etc"
$Env:DATA_DIR = "$Env:BASE_DIR\var"
$Env:LIBEXEC_DIR = "$Env:BASE_DIR\libexec"
$Env:DIST_DIR = "$Env:DATA_DIR\distfiles"

. "$Env:CONFIG_DIR\tap.ps1"
. "$Env:CONFIG_DIR\minikube.ps1"

$credentials = "$Env:CONFIG_DIR\credentials.ps1"
if (!(Test-Path "$credentials"))
{
    throw "credentials.ps1 not found"
}
. "$credentials"

$overrides = "$Env:CONFIG_DIR\overrides.ps1"
if (Test-Path "$overrides")
{
    . "$overrides"
}
