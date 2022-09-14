function Log-Message
{
    $message = $Args
    Write-Host "--- $message" -ForegroundColor Green
}

function Log-Header
{
    $message = $Args
    Write-Host "=== $message" -ForegroundColor Green
}

function Log-Error
{
    $message = $Args
    Write-Host "!!! $message" -ForegroundColor Red
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
    log-message "running: $command"
    Invoke-Expression $command
}
