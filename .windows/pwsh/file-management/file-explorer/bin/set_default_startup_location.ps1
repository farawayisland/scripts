# ~/Projects/Programming/scripts/.windows/pwsh/file-management/file-explorer/bin/set_default_startup_location.ps1
& "$env:USERPROFILE/Projects/Programming/scripts/.windows/pwsh/file-management/file-explorer/unset_default_startup_location.reg"
& "$env:USERPROFILE/Projects/Programming/scripts/.windows/pwsh/file-management/file-explorer/set_default_startup_location.reg"
