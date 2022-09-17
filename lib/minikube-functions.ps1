Function MiniKube-Start
{
    Run-Command $MiniKubeCommand start `
        --driver=$MiniKubeDriver `
        --kubernetes-version=$MiniKubeKubernetesVersion `
        --cpus=$MiniKubeCpus `
        --memory=$MiniKubeMemory `
        --disk-size=$MiniKubeDisk
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
