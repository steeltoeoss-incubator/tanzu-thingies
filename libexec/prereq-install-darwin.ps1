#!/usr/bin/env pwsh

foreach ($PreReq in $PreReqs) {
    Run-Command brew install $PreReq
}

