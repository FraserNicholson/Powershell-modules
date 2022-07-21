param([switch]$deleteStaleBranches)

Import-Module -Name "C:\Projects\Powershell modules\projects"

Push-Location -Path "C:\Projects\Enable\Core"

[System.Array]$releaseBranches = @()

git branch -r | Select-String "origin/release" | Foreach-Object {
    $branchName = ($_ -split '/',2)[1]
    $releaseBranches += $branchName
}

Pop-Location



$projectBasePath = "C:\Projects\Enable\"

foreach ($var in $releaseBranches) {
    write-host $var
}

$projects = Get-ProjectList -noLog

foreach ($project in $projects.Keys) {
    $location = $projectBasePath + $project
    Push-Location -Path $location
    git branch | Select-String -Pattern "fn|main" -NotMatch | Select-String "release" | Foreach-Object {
        $branch = $_.ToString().Trim()
        if ( !$releaseBranches.Contains($branch) ) {
            write-host "Stale release branch in $project : $branch" -ForegroundColor 'Red'

            if ( $deleteStaleBranches ) {
                git branch -D $branch
            }
        } else {
            write-host $branch -ForegroundColor 'green'
        }
    }
    Pop-Location
}
