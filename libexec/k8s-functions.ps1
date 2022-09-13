function create-namespace
{
    log-message "creating namespace ($args)"
    kubectl create namespace $args
}
