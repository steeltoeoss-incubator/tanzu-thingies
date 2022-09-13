function log-message
{
  Write-Host "--- $args" -ForegroundColor Green
}

function log-header
{
  Write-Host "=== $args" -ForegroundColor Green
}

function log-error
{
  Write-Host "!!! $args" -ForegroundColor Red
}

# function die
# {
#   if [[ $# > 0 ]]; then
#     log-error $*
#   fi
#   exit 1
# }

# function run-command
# {
#   cmd=$*
#   log-message "running: $cmd"
#   eval $cmd
# }
