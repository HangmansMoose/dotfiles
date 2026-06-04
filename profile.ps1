# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

$PSStyle.FileInfo.Directory = ""

oh-my-posh --init --shell pwsh --config C:\Users\glens\appdata\local\programs\oh-my-posh\themes\negligible.omp.json | Invoke-Expression



# Aliases 🔗
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#Set-Alias -Name cat -Value bat
Set-Alias -Name df -Value Get-Volume
Set-Alias -Name ff -Value Find-File
Set-Alias -Name grep -Value Find-String
Set-Alias -Name l -Value Get-ChildItemPretty
Set-Alias -Name la -Value Get-ChildItemPretty
Set-Alias -Name ll -Value Get-ChildItemPretty
Set-Alias -Name ls -Value Get-ChildItemPretty
Set-Alias -Name rm -Value Remove-ItemExtended
Set-Alias -Name su -Value Update-ShellElevation
Set-Alias -Name touch -Value New-File
Set-Alias -Name which -Value Show-Command

function Show-Command {
    <#
    .SYNOPSIS
        Displays the definition of a command. Alias: which
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Name
    )
    Write-Verbose "Showing definition of '$Name'"
    Get-Command $Name | Select-Object -ExpandProperty Definition
}

function Remove-ItemExtended {
    <#
    .SYNOPSIS
        Removes an item and (optionally) all its children. Alias: rm
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [switch]$rf,
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Path
    )

    Write-Verbose "Removing item '$Path' $($rf ? 'and all its children' : '')"
    Remove-Item $Path -Recurse:$rf -Force:$rf
}

function Get-ChildItemPretty {
    <#
    .SYNOPSIS
        Runs eza with a specific set of arguments. Plus some line breaks before and after the output.
        Alias: ls, ll, la, l
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, Position = 0)]
        [string]$Path = $PWD
    )

    Write-Host ""
    eza -a -l --header --icons --hyperlink --time-style relative $Path
    Write-Host ""
}

function Update-Software {
    <#
    .SYNOPSIS
        Updates all software installed via Winget & Chocolatey. Alias: us
    #>
    Write-Verbose "Updating software installed via Winget & Chocolatey"
    sudo winget upgrade --all --include-unknown --silent --verbose
    sudo choco upgrade all -y
    $ENV:SOFTWARE_UPDATE_AVAILABLE = ""
}

function Find-File {
    <#
    .SYNOPSIS
        Finds a file in the current directory and all subdirectories. Alias: ff
    #>
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline, Mandatory = $true, Position = 0)]
        [string]$SearchTerm
    )

    Write-Verbose "Searching for '$SearchTerm' in current directory and subdirectories"
    $result = Get-ChildItem -Recurse -Filter "*$SearchTerm*" -ErrorAction SilentlyContinue

    Write-Verbose "Outputting results to table"
    $result | Format-Table -AutoSize
}

function Update-ShellElevation {
    <#
    .SYNOPSIS
        Elevates the current shell to run as an administrator. Alias: su
    #>
    Write-Verbose "Elevating shell to run as administrator"
    sudo -E pwsh -NoLogo -Interactive -NoExit -c "Clear-Host"
}

# Environment Variables 🌐
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
$ENV:BAT_CONFIG_DIR = "$ENV:WindotsLocalRepo\bat"
$ENV:FZF_DEFAULT_OPTS = '--color=fg:-1,fg+:#ffffff,bg:-1,bg+:#3c4048 --color=hl:#5ea1ff,hl+:#5ef1ff,info:#ffbd5e,marker:#5eff6c --color=prompt:#ff5ef1,spinner:#bd5eff,pointer:#ff5ea0,header:#5eff6c --color=gutter:-1,border:#3c4048,scrollbar:#7b8496,label:#7b8496 --color=query:#ffffff --border="rounded" --border-label="" --preview-window="border-rounded" --height 40% --preview="bat -n --color=always {}"'

Set-PSReadLineOption -Colors $colors
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineOption -PredictionViewStyle InlineView
Set-PSReadLineKeyHandler -Function AcceptSuggestion -Key Alt+l
Import-Module -Name CompletionPredictor

# Find all Launch-VsDevShell.ps1 on the system
$vswhere = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
$vsPath = & $vswhere -latest -property installationPath
& "$vsPath\Common7\Tools\Launch-VsDevShell.ps1" -Arch amd64 -SkipAutomaticLocation