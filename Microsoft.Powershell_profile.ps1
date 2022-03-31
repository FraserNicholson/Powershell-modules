$Env:PSModulePath = $Env:PSModulePath+";C:\Projects\Powershell modules"

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
