# ~/Projects/Programming/scripts/.windows/pwsh/package-management/winget/wingetfiles/bin/wingetfile.ps1

# Elevate current PowerShell session if required
## Sources:
## https://stackoverflow.com/a/11242455
## https://stackoverflow.com/a/70869951
## https://superuser.com/a/1248390
function Pass-Parameters {
    Param ([hashtable]$NamedParameters)
    return ($NamedParameters.GetEnumerator()|%{"-$($_.Key) `"$($_.Value)`""}) -join " "
}

if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
  if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
    $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + (Pass-Parameters $MyInvocation.BoundParameters) + " " + $MyInvocation.UnboundArguments
    if ((Get-Command "pwsh.exe" -ErrorAction SilentlyContinue) -eq $null) {
      Start-Process -FilePath wt.exe -Verb RunAs -ArgumentList "powershell", $CommandLine
    } else {
      Start-Process -FilePath wt.exe -Verb RunAs -ArgumentList "pwsh", $CommandLine
    }
    Exit
 }
}

Write-Host "`nThis script will now be run as administrator."
Read-Host -Prompt "Press any key then return to continue or CTRL+C to quit" | Out-Null
Clear-Host

# Install VCLibs, Visual Studio, and WinUI
# (Workloads must include "WinUI application development" with the "C++ (v143) Universal Windows Tools" option)
## Sources:
## https://learn.microsoft.com/en-us/troubleshoot/developer/visualstudio/cpp/libraries/c-runtime-packages-desktop-bridge#how-to-install-and-update-desktop-framework-packages
## https://learn.microsoft.com/en-us/visualstudio/releases/2022/release-history#evergreen-bootstrappers
if ((Get-Command "C:\Program Files\Microsoft Visual Studio\2022\Enterprise\Common7\IDE\devenv.exe" -ErrorAction SilentlyContinue) -eq $null) {
  Write-Host "`n`n`n`n`n`n`n`n`nDownloading Visual Studio Enterprise...`n"
  Invoke-WebRequest -Uri "https://aka.ms/vs/17/release/vs_enterprise.exe" -OutFile "$env:USERPROFILE/Downloads/vs_enterprise.exe"
  & "$env:USERPROFILE/Downloads/vs_enterprise.exe"
  Write-Host "Done.`n"
  Write-Host "After ensuring Visual Studio has been successfully installed with the 'WinUI"
  Write-Host "application development' workload with the 'C++ (v143) Universal Windows Tools'"
  Read-Host -Prompt "option, press any key then return to continue or CTRL+C to quit" | Out-Null
}

# Install WinGet
## Sources:
## https://github.com/nano11-dev/winget-stuff
## https://learn.microsoft.com/en-us/windows/package-manager/winget/#install-winget-on-windows-sandbox
## https://learn.microsoft.com/en-us/windows/iot/iot-enterprise/deployment/install-winget-windows-iot?source=recommendations#download-winget
## https://stackoverflow.com/a/52844045
## https://stackoverflow.com/a/57554679
## https://stackoverflow.com/a/61246161
Write-Host "`nInstalling WinGet PowerShell module from PSGallery..."
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

if (-not $(Get-PackageSource -Name NuGet -ProviderName NuGet -ErrorAction Ignore)) {
  Register-PackageSource -Name NuGet -ProviderName NuGet -Location "https://api.nuget.org/v3/index.json"
}

Install-Module -Name Microsoft.WinGet.Client -Force -Repository PSGallery | Out-Null
Write-Host "Using Repair-WinGetPackageManager cmdlet to bootstrap WinGet..."
Repair-WinGetPackageManager -AllUsers
Write-Host "Done.`n"
Read-Host -Prompt "Press any key then return to continue or CTRL+C to quit" | Out-Null

# Run WinGet package management script
## Sources:
## https://github.com/microsoft/winget-cli/discussions/4100#discussioncomment-8243917
## https://www.xda-developers.com/made-simple-script-install-all-apps-new-pc-using-winget-you-can-make-your-own
Write-Host "`nThe script will now install all your apps. Feel free to grab a coffee or keep working on something else!"

## List of packages to be installed
$packages = @(
  ### Application launchers
  @{name = "Flow-Launcher.Flow-Launcher" },

  ### Audio software
  #### Audio players
  # @{name = "PeterPawlowski.foobar2000" },

  #### CD rippers
  # @{name = "AndreWiethoff.ExactAudioCopy" },

  ### Build automation tools
  @{name = "GnuWin32.Make" },

  ### Clipboard tools
  @{name = "equalsraf.win32yank" },

  ### Command-line fuzzy finders
  @{name = "junegunn.fzf" },

  ### Compatibility layers
  # @{name = "Cygwin.Cygwin" },

  ### Compilers
  @{name = "BrechtSanders.WinLibs.POSIX.UCRT" },

  ### Directory-searching utilities
  @{name = "sharkdp.fd" },
  @{name = "GnuWin32.FindUtils" },

  ### Document converters
  # @{name = "JohnMacFarlane.Pandoc" },

  ### Document viewers and PDF tools
  #### Document viewers
  # @{name = "ahrm.sioyek" },

  #### PDF tools
  # @{name = "cpdf" },
  # @{name = "ArtifexSoftware.GhostScript" },
  # @{name = "PDFLabs.PDFtk.Server" },
  # @{name = "XpdfReader.XpdfReader" },

  ### Database software
  # @{name = "DBBrowserForSQLite.DBBrowserForSQLite" },

  ### Download managers
  @{name = "cURL.cURL" },
  # @{name = "AppWork.JDownloader" },
  @{name = "JernejSimoncic.Wget" },
  # @{name = "yt-dlp.yt-dlp" },

  ### File archivers
  @{name = "7zip.7zip" },
  @{name = "GnuWin32.Gzip" },
  @{name = "GnuWin32.UnZip" },

  ### File comparison tools
  @{name = "GnuWin32.DiffUtils" },

  ### File synchronization software

  ### Image software
  #### Image organizers
  # @{name = "XnSoft.XnViewMP" },

  #### Raster graphics editors
  # @{name = "ImageMagick.ImageMagick" },

  ### Instant-messaging service clients
  # @{name = "Discord.Discord" },

  ### Minecraft launchers and tools
  # @{name = "PrismLauncher.PrismLauncher" },

  ### Miscellaneous utilities
  @{name = "sharkdp.bat" },
  @{name = "uutils.coreutils" },

  ### Package managers
  @{name = "Chocolatey.Chocolatey" },
  @{name = "MartiCliment.UniGetUI" },

  ### Peer-to-peer file-sharing software
  # @{name = "Nicotine+.Nicotine+" },
  # @{name = "qBittorrent.qBittorrent" },

  ### Personal knowledge bases and and note-taking software
  # @{name = "Obsidian.Obsidian" },

  ### Programming Language-Related Installations
  #### Java
  # @{name = "EclipseAdoptium.Temurin.21.JDK" },

  #### JavaScript
  # @{name = "OpenJS.NodeJS" },

  #### Lua
  # @{name = "rjpcomputing.luaforwindows" },

  #### Perl
  # @{name = "StrawberryPerl.StrawberryPerl" },

  #### Python
  # @{name = "astral-sh.uv" },

  ### Reference management software
  # @{name = "Elsevier.MendeleyReferenceManager" },

  ### Roblox launchers and tools
  # @{name = "pizzaboxer.Bloxstrap" },

  ### Search tools
  @{name = "GnuWin32.Grep" },
  @{name = "BurntSushi.ripgrep.MSVC" },

  ### Shells
  @{name = "Microsoft.PowerShell" },

  ### Spaced repetition software
  # @{name = "Anki.Anki" },

  ### Tag editors
  # @{name = "OliverBetz.ExifTool" },

  #### Audio tag editors
  # @{name = "FlorianHeidenreich.Mp3tag" },

  ### Terminal emulators
  @{name = "wez.wezterm" },
  @{name = "Microsoft.WindowsTerminal" },

  ### Terminal pagers
  @{name = "jftuga.less" },

  ### Text editors and integrated development environments
  @{name = "Orwell.Dev-C++" },
  # @{name = "EclipseFoundation.Eclipse.Java" },
  @{name = "Neovim.Neovim" },
  @{name = "Notepad++.Notepad++" },
  @{name = "vim.vim" },
  # @{name = "Microsoft.VisualStudioCode" },

  #### Neovim clients
  @{name = "Neovide.Neovide" },

  ### Text-file format converters
  # @{name = "waterlan.dos2unix" },

  ### Text processing utilities
  # @{name = "mbuilov.sed" },

  ### Typesetting software
  #### TeX distributions
  # @{name = "MiKTeX.MiKTeX" },

  ### Version control systems
  @{name = "Git.Git" },
  @{name = "GitHub.cli" }

  ### Videoconferencing software
  # @{name = "Zoom.Zoom" },

  #### Video-game digital-distribution service clients
  # @{name = "Valve.Steam" },

  ### Video software and MKV tools
  #### MKV tools
  # @{name = "MoritzBunkus.MKVToolNix" },

  #### Video software
  ##### Blu-ray rippers
  # @{name = "GuinpinSoft.MakeMKV" },

  ##### Subtitle editors
  # @{name = "Nikse.SubtitleEdit" },

  ### Web browsers
  # @{name = "Google.Chrome" },
  # @{name = "Mozilla.Firefox" },
);

## Upgrade WinGet
Write-Host "`nInstalling and upgrading packages..."
winget upgrade Microsoft.AppInstaller

## Install each package in the list
ForEach ($package in $packages) {
  $listPackage = winget list --exact -q $package.name
  if (![String]::Join("", $listPackage).Contains($package.name)) {
    Write-Host "Installing" $package.name
    winget install -e -h --accept-package-agreements --accept-source-agreements --id $package.name --source winget
  }
  else {
    Write-Host "Skipping" $package.name "(already installed)"
  }
}

## Upgrade each package
winget upgrade --all
Write-Host "Done.`n"
Read-Host -Prompt "Press any key then return to continue or CTRL+C to quit" | Out-Null
