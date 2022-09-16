If ($IsMacOs)
{
    $PlatformName = "darwin"
    $PlatformArchive = "tar"
    $PlatformExe = ""
}
ElseIf ($IsLinux)
{
    $PlatformName = "linux"
    $PlatformArchive = "tar"
    $PlatformExe = ""
}
Else
{
    $PlatformName = "windows"
    $PlatformArchive = "zip"
    $PlatformExe = ".exe"
}
