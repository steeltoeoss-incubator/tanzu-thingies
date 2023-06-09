function Pivnet-Download {
    param
    (
        [parameter (Mandatory = $True)]
        [string]$Slug,
        [parameter (Mandatory = $True)]
        [string]$Release,
        [parameter (Mandatory = $True)]
        [string]$Platform
    )

    Log-Crumb "downloading $Slug $Release ($Platform)"
    if ($IsWindows) {
        $id = pivnet product-files `
            --product-slug=$Slug `
            --release-version=$Release `
            --format=json | ConvertFrom-Json | Where name -match $platform | Select id -ExpandProperty id
    } else {
        $id = pivnet product-files `
            --product-slug $Slug `
            --release-version $Release `
            --format=json | jq ".[] | select(.aws_object_key | test(""$Platform"")) | .id"
    }
    if ($LastExitCode -ne 0) {
        exit $LastExitCode
    }

    New-Item -ItemType Directory $LocalDistDir -Force | Out-Null
    pivnet download-product-files --product-slug=$Slug --release-version=$Release --product-file-id=$id --download-dir=$LocalDistDir
    if ($LastExitCode -ne 0) {
        exit $LastExitCode
    }
}
