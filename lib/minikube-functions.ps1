Enum MiniKubeStatus
{
    Absent
    Running
    Stopped
}

Function MiniKube-Status
{
    $status = "$(& $MiniKubeCommand status 2>&1 | Select-String "host:")"
    If (($status -eq "") -Or ($status -Match "Nonexistent"))
    {
        Return [MiniKubeStatus]::Absent
    }
    If ($status -Match "Running")
    {
        Return [MiniKubeStatus]::Running
    }
    If ($status -Match "Stopped")
    {
        Return [MiniKubeStatus]::Stopped
    }
    Throw "Unable to determine minikube status"
}

Function MiniKube-Create
{
    Run-Command $MiniKubeCommand start `
        --driver=$MiniKubeDriver `
        --kubernetes-version=$KubernetesVersion `
        --cpus=$MiniKubeCpus `
        --memory=$MiniKubeMemory `
        --disk-size=$MiniKubeDisk
}

Function MiniKube-Start
{
    Run-Command $MiniKubeCommand start
}

Function MiniKube-Stop
{
    Run-Command $MiniKubeCommand stop
}

Function MiniKube-Delete
{
    Run-Command $MiniKubeCommand delete
}

Function MiniKube-Tunnel
{
    Run-Command $MiniKubeCommand tunnel
}
