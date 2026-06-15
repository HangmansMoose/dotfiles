# Original script from Scott McKendry's WINDOTS repo https://github.com/scottmckendry/windots

#Requires -RunAsAdministrator
#Requires -Version 7

# Linked Files (Destination => Source)
#$symlinks = @{
#    $PROFILE.CurrentUserAllHosts                                                                    = ".\Profile.ps1"
#    "$HOME\AppData\Local\nvim"                                                                      = ".\nvim"
#    "$HOME\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" = ".\windowsterminal\settings.json"
#    "$HOME\.gitconfig"                                                                              = ".\.gitconfig"
#    "$HOME\AppData\Roaming\Code\User\settings.json"                                                 = ".\vscode\settings.json"
#    "$HOME\.config\wezterm"                                                                         = ".\wezterm"
#    "$ENV:PROGRAMFILES\WezTerm\wezterm_modules"                                                     = ".\wezterm\"
#}

# Winget & choco dependencies
$wingetDeps = @(
    "microsoft.powershell"
	"microsoft.coreutils"
    "git.git"
    "github.cli"
    "kitware.cmake"
    "Microsoft.VisualStudioCode"
    "Notepad++.Notepad++"
    "neovim.neovim"
	"odin-lang.odin"
)

# Set working directory
Set-Location $PSScriptRoot
[Environment]::CurrentDirectory = $PSScriptRoot

Write-Host "Installing missing dependencies..."
$installedWingetDeps = winget list | Out-String
foreach ($wingetDep in $wingetDeps) {
    if ($installedWingetDeps -notmatch $wingetDep) {
        winget install --id $wingetDep
    }
}

# Refresh Environment Variables
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")

