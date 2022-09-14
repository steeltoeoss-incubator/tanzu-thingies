if ($IsMacOs)
{
    $Env:PLATFORM = "darwin"
    $Env:ARCHIVE = "tar"
    $Env:EXECUTABLE = ""
}
elseif ($IsLinux)
{
    $Env:PLATFORM = "linux"
    $Env:ARCHIVE = "tar"
    $Env:EXECUTABLE = ""
}
else
{
    $Env:PLATFORM = "windows"
    $Env:ARCHIVE = "zip"
    $Env:EXECUTABLE = ".exe"
}
