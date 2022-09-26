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
        --product-slug $Slug `
        --release-version $Release `
        --format=json | jq ".[] | select(.aws_object_key | test(""$Platform"")) | .id"
    pivnet download-product-files `
        --product-slug=$Slug `
        --release-version=$Release `
        --product-file-id=$id `
        --download-dir=$LocalDistDir
}

