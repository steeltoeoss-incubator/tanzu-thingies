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

Function Extract
{
    Param
    (
        [Parameter (Mandatory = $True)]
        [string]$Archive,
        [Parameter (Mandatory = $True)]
        [string]$OutDir
    )
    Log-Crumb "extracting $Archive -> $OutDir"
    If ($Archive -Match ".zip$")
    {
        unzip "$Archive" -d "$OutDir" | Out-Null
    }
    Else
    {
        tar xf $Archive -C $OutDir
    }
}

Function Make-Executable
{
    Param
    (
        [Parameter (Mandatory = $True)]
        [string]$Path
    )
    If (!($IsWindows))
    {
        Log-Crumb "making executable: $Path"
        chmod +x $Path
    }
}

Function Substitute-Env
{
    Param
    (
        [Parameter (Mandatory = $True)]
        [string]$InFile,
        [Parameter (Mandatory = $True)]
        [string]$OutFile
    )
    If ($IsWindows)
    {
        Run-Command envsubst -i $InFile -o $OutFile
    }
    Else
    {
        cat $InFile | envsubst > $OutFile
    }
}

Function Windows-2-Unix
{
    "$Args" -Replace "\\", "/" -Replace "C:", "/mnt/c"
}
