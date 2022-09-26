If ($IsMacOs)
{
    $PlatformName = "darwin"
    $PlatformExe = ""
}
ElseIf ($IsLinux)
{
    $PlatformName = "linux"
    $PlatformExe = ""
}
Else
{
    $PlatformName = "windows"
    $PlatformExe = ".exe"
}
