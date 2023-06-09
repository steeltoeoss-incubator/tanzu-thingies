#!/usr/bin/env pwsh

foreach ($PreReq in $PreReqs) {
    brew install $PreReq
}
