if ($IsMacOs) {
    $PlatformName = "darwin"
    $PlatformExe = ""
} elseif ($IsLinux) {
    $PlatformName = "linux"
    $PlatformExe = ""
} else {
    $PlatformName = "windows"
    $PlatformExe = ".exe"
}
