Function Pivnet-Download
{
    Param
    (
        [Parameter (Mandatory = $True)]
        [string]$Slug,
        [Parameter (Mandatory = $True)]
        [string]$Release,
        [Parameter (Mandatory = $True)]
        [string]$Platform
    )
    Log-Crumb "downloading $Slug $Release"
    $id = pivnet product-files `
        --product-slug=$Slug `
        --release-version=$Release `
        --format=json | ConvertFrom-Json | Where name -match $platform | Select id -ExpandProperty id
    If ($LastExitCode -ne 0)
    {
        Exit $LastExitCode
    }
    pivnet download-product-files --product-slug=$Slug --release-version=$Release --product-file-id=$id --download-dir=$LocalDistDir
    If ($LastExitCode -ne 0)
    {
        Exit $LastExitCode
    }
}

