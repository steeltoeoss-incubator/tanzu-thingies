. "$ConfigDir/look-n-feel.ps1"

Function Log-Info
{
    $message = $Args
    Write-Host "--- $message" -ForegroundColor $InfoColor
}

Function Log-Success
{
    $message = $Args
    Write-Host "--- $message" -ForegroundColor $SuccessColor
}

Function Log-Error
{
    $message = $Args
    Write-Host "!!! $message" -ForegroundColor $ErrorColor
}

Function Log-Header
{
    $message = $Args
    Write-Host "=== $message" -ForegroundColor $HeaderColor
}

Function Log-Crumb
{
    $message = $Args
    Write-Host "--- $message" -ForegroundColor $CrumbColor
}

Function Die
{
    If ($Args)
    {
        $message = "$Args"
        Log-Error $message
    }
    Exit 1
}

Function Run-Command
{
    $command = "$Args"
    Log-Crumb "running: $command"
    Invoke-Expression $command
}
