

Import-Module z
Import-Module posh-git


function Get-DatabaseServer() {
    Get-Content "C:\Projects\Enable\Core\dev-database-server.txt"
}
function Set-DatabaseServer() {
    $branch = Read-Host "Enter the dev database server name"
    Get-ChildItem -Path "C:\Projects" -Depth 2 -Filter dev-database-server.txt | Set-Content -Value $branch -NoNewLine
}
function Get-DevBranch() {
    Get-Content "C:\Projects\Enable\Core\dev-branch.txt"
}

function Set-DevBranch() {
    $branch = Read-Host "Enter the branch name"
    Get-ChildItem -Path "C:\Projects" -Depth 2 -Filter dev-branch.txt | Set-Content -Value $branch -NoNewLine
}

function Sync-Profile() {
    Copy-Item -Path 'C:\Program Files (x86)\PowerShell\7\Microsoft.PowerShell_profile.ps1' -Destination "C:\Projects\Powershell modules"
}

function Open-PSProfile() {
    $path =  $PSHome + "\Microsoft.PowerShell_profile.ps1"
    code $path
}

function Elevate { 
    param (
    [switch]$noExit
    )

    if ( ! (Test-Administrator) ) {
        start-process wt -Verb runas -ArgumentList "-d ."
        if (!$noExit) {
            exit
        }
    }
    else { Write-Warning "Session is already elevated" }
}

function GitPushCurrentBranch {
    $currentBranch = &git rev-parse --abbrev-ref HEAD 

    Invoke-Expression "git push --set-upstream origin $currentBranch"
}

function Remove-BinObj {
    param (
        [string]$Path
    )

    if ($Path) {
        Get-ChildItem -Path $Path -include bin,obj -Force -Recurse  -ErrorAction SilentlyContinue `
        | remove-item -Force -Recurse -ErrorAction SilentlyContinue
    } else {
        Write-Host "Error - Please provide a project location" -ForegroundColor "Red"
    }
}

function GitSetAsSaveRepo {
    $location = [string](Get-Location)

    $location = $location.Replace("\","/")

    git config --global --add safe.directory $location
}