function Pivnet-Download {
    param
    (
        [parameter (Mandatory = $True)]
        [string]$Product,
        [parameter (Mandatory = $True)]
        [string]$Version
    )

    Log-Info "fetching TAP $Version $Product"

    Log-Crumb "getting file ID for TAP $Version $Product"
    if ($IsWindows) {
        $fileId = pivnet product-files `
            --product-slug=$TanzuSlug `
            --release-version=$Version `
            --format=json | ConvertFrom-Json | Where name -match $platform | Select id -ExpandProperty id
    } else {
        $fileId = Run-Command pivnet product-files `
            --product-slug $TanzuSlug `
            --release-version $Version `
            --format=json | jq ".[] | select(.name == ""$Product"") | .id"
    }

    if ($fileId -eq $null) {
        Log-Warning "no file ID found for TAP $Version $Product"
        return
    }

    Log-Crumb "downloading file ID $fileId "
    New-Item -ItemType Directory $LocalCacheDir -Force | Out-Null
    Run-Command pivnet download-product-files `
        --product-slug=$TanzuSlug `
        --release-version=$Version `
        --product-file-id=$fileId `
        --download-dir=$LocalCacheDir
}
