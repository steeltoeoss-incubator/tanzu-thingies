function K8s-Create-Namespace
{
    Log-Message "creating namespace ($Args)"
    Run-Command kubectl create namespace "$Args"
}
