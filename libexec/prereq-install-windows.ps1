#!/usr/bin/env pwsh

foreach ($PreReq in $PreReqs) {
    scoop install $PreReq
}
