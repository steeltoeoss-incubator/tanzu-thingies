$Env:BASE_DIR = Resolve-Path "$PSScriptRoot\.."
$Env:BIN_DIR = "$Env:BASE_DIR\bin"
$Env:CONFIG_DIR = "$Env:BASE_DIR\etc"
$Env:DATA_DIR = "$Env:BASE_DIR\share"
$Env:LIBEXEC_DIR = "$Env:BASE_DIR\libexec"
$Env:LOCAL_DIR = "$Env:BASE_DIR\local"
$Env:LOCAL_BIN_DIR = "$Env:LOCAL_DIR\bin"
$Env:LOCAL_DIST_DIR = "$Env:LOCAL_DIR\dist"
$Env:LOCAL_TOOL_DIR = "$Env:LOCAL_DIR\tools"

. "$Env:LIBEXEC_DIR\sh-functions.ps1"

$Env:PLATFORM = "windows"

$credentials = "$Env:CONFIG_DIR\credentials.ps1"
if (!(Test-Path "$credentials"))
{
    throw "credentials.ps1 not found"
}
. "$credentials"

. "$Env:CONFIG_DIR\tap.ps1"
. "$Env:CONFIG_DIR\minikube.ps1"

$overrides = "$Env:CONFIG_DIR\overrides.ps1"
if (Test-Path "$overrides")
{
    . "$overrides"
}
