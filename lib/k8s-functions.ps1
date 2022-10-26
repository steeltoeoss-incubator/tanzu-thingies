Function K8s-Create-Namespace
{
    Param
    (
        [Parameter (Mandatory = $True)]
        [string]$Namespace
    )
    Log-Info "k8s: creating namespace $Namespace"
    Run-Command kubectl create namespace "$Namespace"
}

Function K8s-Apply
{
    Param
    (
        [Parameter (Mandatory = $True)]
        [string]$Namespace,
        [Parameter (Mandatory = $True)]
        [string]$FileName
    )
    Log-Info "k8s: applying $FileName ($Namespace)"
    Run-Command kubectl apply --namespace $Namespace --filename $FileName
}

Function K8s-Wait-For-Resource
{
    Param
    (
        [Parameter (Mandatory = $True)]
        [string]$Namespace,
        [Parameter (Mandatory = $True)]
        [string]$Resource,
        [Parameter (Mandatory = $True)]
        [string]$Status
    )
    Log-Info "k8s: waiting for $Resource -> $Status ($Namespace)"
    $Max = 120
    $Count = 0
    While ($Count -lt $Max)
    {
        $current = kubectl get --namespace $Namespace $Resource --no-headers `
            | Select-String $Status -NotMatch
        If (!($current))
        {
            Break
        }
        ++$Count
        Log-Crumb "waiting for $Resource to be $Status ($Namespace) [$Count/$Max]"
        Start-Sleep -s 1
    }
}

