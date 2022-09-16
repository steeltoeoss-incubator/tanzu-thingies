#!/usr/bin/env pwsh

foreach ($prereq in $prereqs)
{
    brew install $prereq
}
