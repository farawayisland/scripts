# ~/Projects/Programming/scripts/.windows/pwsh/file-management/file-explorer/bin/set_show_more_options_as_default.ps1
# Set "Show more options" as default
REG ADD "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve
