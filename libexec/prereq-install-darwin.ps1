#!/usr/bin/env pwsh

ForEach ($PreReq in $PreReqs)
{
    brew install $PreReq
}
