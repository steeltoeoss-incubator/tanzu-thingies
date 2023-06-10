function Pivnet-Download {
    param
    (
        [parameter (Mandatory = $True)]
        [string]$Product,
        [parameter (Mandatory = $True)]
        [string]$Release
    )

    Log-Crumb "getting file ID for $Product $Release"
    if ($IsWindows) {
        $fileId = pivnet product-files `
            --product-slug=$TanzuSlug `
            --release-version=$Release `
            --format=json | ConvertFrom-Json | Where name -match $platform | Select id -ExpandProperty id
    } else {
        $fileId = Run-Command pivnet product-files `
            --product-slug $TanzuSlug `
            --release-version $Release `
            --format=json | jq ".[] | select(.name == ""$Product"") | .id"
    }

    Log-Crumb "downloading file ID $fileId "
    New-Item -ItemType Directory $LocalDistDir/$TapVersion -Force | Out-Null
    Run-Command pivnet download-product-files `
        --product-slug=$TanzuSlug `
        --release-version=$Release `
        --product-file-id=$fileId `
        --download-dir=$LocalDistDir/$TapVersion
    if ($LastExitCode -ne 0) {
        exit $LastExitCode
    }
}
