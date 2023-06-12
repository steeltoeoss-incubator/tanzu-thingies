. "$ConfigDir/look-n-feel.ps1"

function Log-Info {
    $message = $Args
    Write-Host "--- $message" -ForegroundColor $InfoColor
}

function Log-Success {
    $message = $Args
    Write-Host "--- $message" -ForegroundColor $SuccessColor
}

function Log-Warning {
    $message = $Args
    Write-Host "!!! $message" -ForegroundColor $WarningColor
}

function Log-Error {
    $message = $Args
    Write-Host "!!! $message" -ForegroundColor $ErrorColor
}

function Log-Header {
    $message = $Args
    Write-Host "=== $message" -ForegroundColor $HeaderColor
}

function Log-Crumb {
    $message = $Args
    Write-Host "--- $message" -ForegroundColor $CrumbColor
}

function Die {
    if ($Args) {
        $message = "$Args"
        Log-Error $message
    }
    exit 1
}

function Run-Command {
    $command = "$Args"
    Log-Crumb "running: $command"
    Invoke-Expression $command
}

function Extract {
    param
    (
        [parameter (Mandatory = $True)]
        [string]$Archive,
        [parameter (Mandatory = $True)]
        [string]$OutDir
    )
    Log-Crumb "extracting $Archive -> $OutDir"
    if ($Archive -Match ".zip$") {
        unzip "$Archive" -d "$OutDir" | Out-Null
    } else {
        tar xf $Archive -C $OutDir
    }
}

function Make-Executable {
    param
    (
        [parameter (Mandatory = $True)]
        [string]$Path
    )
    if (!($IsWindows)) {
        Log-Crumb "making executable: $Path"
        chmod +x $Path
    }
}
