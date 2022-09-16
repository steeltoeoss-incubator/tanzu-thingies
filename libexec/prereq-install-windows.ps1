#!/usr/bin/env pwsh

foreach ($prereq in $prereqs)
{
    scoop install $prereq
}
