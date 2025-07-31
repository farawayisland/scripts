# ~/Projects/Programming/scripts/.windows/pwsh/file-management/file-explorer/bin/remove_home_and_gallery.ps1
# Remove "Home" from File Explorer sidebar
REG ADD "HKEY_CURRENT_USER\Software\Classes\CLSID\{f874310e-b6b7-47dc-bc84-b9e6b38f5903}" /f /v "System.IsPinnedToNameSpaceTree" /t REG_DWORD /d 0x00000000

# Remove "Gallery" from File Explorer sidebar
REG ADD "HKEY_CURRENT_USER\Software\Classes\CLSID\{e88865ea-0e1c-4e20-9aa6-edcd0212c87c}" /f /v "System.IsPinnedToNameSpaceTree" /t REG_DWORD /d 0x00000000
