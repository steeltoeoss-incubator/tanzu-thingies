. "$Env:CONFIG_DIR\look-n-feel.ps1"

function Log-Info
{
    $message = $Args
    Write-Host "--- $message" -ForegroundColor $Env:InfoColor
}

function Log-Error
{
    $message = $Args
    Write-Host "!!! $message" -ForegroundColor $Env:ErrorColor
}

function Log-Header
{
    $message = $Args
    Write-Host "=== $message" -ForegroundColor $Env:HeaderColor
}

function Die
{
    if ($Args)
    {
        $message = "$Args"
        Log-Error $message
    }
    exit 1
}

function Run-Command
{
    $command = "$Args"
    Log-Info "running: $command"
    Invoke-Expression $command
}
