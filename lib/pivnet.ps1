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
    Log-Crumb "downloading $Slug $Release ($Platform)"
    If ($IsWindows)
    {
        $id = pivnet product-files `
            --product-slug=$Slug `
            --release-version=$Release `
            --format=json | ConvertFrom-Json | Where name -match $platform | Select id -ExpandProperty id
    }
    Else
    {
        $id = pivnet product-files `
            --product-slug $Slug `
            --release-version $Release `
            --format=json | jq ".[] | select(.aws_object_key | test(""$Platform"")) | .id"
    }

    If ($LastExitCode -ne 0)
    {
        Exit $LastExitCode
    }
    New-Item -ItemType Directory $LocalDistDir -Force
    pivnet download-product-files --product-slug=$Slug --release-version=$Release --product-file-id=$id --download-dir=$LocalDistDir
    If ($LastExitCode -ne 0)
    {
        Exit $LastExitCode
    }
}

