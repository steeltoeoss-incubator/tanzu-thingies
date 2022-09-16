function K8s-Create-Namespace
{
    Log-Info "creating namespace ($Args)"
    Run-Command kubectl create namespace "$Args"
}
