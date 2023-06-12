#!/usr/bin/env pwsh

foreach ($PreReq in $PreReqs) {
    Run-Command scoop install $PreReq
}
