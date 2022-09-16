#!/usr/bin/env pwsh

ForEach ($PreReq in $PreReqs)
{
    scoop install $PreReq
}
